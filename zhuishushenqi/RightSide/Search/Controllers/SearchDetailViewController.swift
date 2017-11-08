//
//  SearchDetailViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/11.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork
//import YTKKeyValueStore

class SearchDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,SearchViewDelegate {

    var books = [Book]()
    var searchWords:String = ""
    var store:YTKKeyValueStore?
    let storeKey = "SearchHistory"
    var historyList:[String]?
    lazy var searchView:SearchView = {
       let searchView = SearchView(frame: CGRect(x: 0, y: kNavibarH + 55, width: ScreenWidth, height: ScreenHeight - kNavibarH - 55))
        searchView.delegate = self
        return searchView
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavibarH + 55, width: ScreenWidth, height: ScreenHeight - kNavibarH - 55), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        return tableView
    }()
    
    fileprivate lazy var searchController:UISearchController = {
        let searchVC:UISearchController = UISearchController(searchResultsController: nil)
        searchVC.searchBar.placeholder = "输入书名或作者名"
        searchVC.searchResultsUpdater = self
        searchVC.delegate = self
        searchVC.searchBar.delegate = self
        searchVC.hidesNavigationBarDuringPresentation = true
        searchVC.searchBar.sizeToFit()
        searchVC.searchBar.backgroundColor = UIColor.darkGray
        return searchVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "搜索"
        self.automaticallyAdjustsScrollViewInsets = false
       requestHot()
        initSubview()
        let store  = YTKKeyValueStore(dbWithName: dbName)
        
        if store?.isTableExists(searchHistory) == false {
            store?.createTable(withName: searchHistory)
        }
        self.store = store
        self.historyList = store?.getObjectById(storeKey, fromTable: searchHistory) as? [String]
        searchView.historyList = historyList

    }
    
    func searchViewClearButtonClicked() {
        store?.clearTable(searchHistory)
        self.historyList = store?.getObjectById(storeKey, fromTable: searchHistory) as? [String]
        searchView.historyList = historyList
    }
    
    func searchViewHotWordClick(index: Int){
        searchController.dismiss(animated: true, completion: nil)
        searchController.searchBar.text = searchView.hotWords[index]
        self.saveHistoryList(searchBar: searchController.searchBar)
        self.searchWords = searchController.searchBar.text ?? ""
        requestData()
    }
    
    func requestData(){
//        http://api.zhuishushenqi.com/book/fuzzy-search?query=偷&start=0&limit=100
        let urlString = "\(BASEURL)/book/fuzzy-search"
        let param = ["query":self.searchWords,"start":"0","limit":"100"]
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            QSLog(response.json)
            
            do{
                if let books = response.json?.object(forKey: "books") {
                    self.books =  try XYCBaseModel.model(withModleClass: Book.self, withJsArray:books as! [AnyObject]) as! [Book]
                }
            }catch{
                
            }
            DispatchQueue.main.async {
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func requestHot() -> Void {
        //        http://api.zhuishushenqi.com/book/hot-word
        let urlString = "\(BASEURL)/book/hot-word"
        QSNetwork.request(urlString) { (response) in
            QSLog(response.json)
            if let json = response.json {
                DispatchQueue.main.async {
                    self.searchView.hotWords = json["hotWords"] as? [String] ?? [""]
                    self.view.addSubview(self.searchView)
                }
            }
        }
    }
    
    func initSubview(){
        let bgView = UIView()
//        [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
        bgView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
        bgView.frame = CGRect(x: 0, y: kNavibarH, width: self.view.bounds.width, height: 55)
        bgView.addSubview(self.searchController.searchBar)
        view.addSubview(bgView)
    }
    
    func isExistSearchWord(key:String)->Bool{
        var isExist = false
        if let list = historyList {
            for item in list {
                if item == key {
                    isExist = true
                }
            }
        }
        return isExist
    }
    
    func willPresentSearchController(_ searchController: UISearchController){
        UIView.animate(withDuration: 0.35) {
            self.searchView.frame = CGRect(x: 0, y: kNavibarH, width: ScreenWidth, height: ScreenHeight - kNavibarH)
            self.view.addSubview(self.searchView)
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.35) {
            self.searchView.frame = CGRect(x: 0, y: kNavibarH + 55, width: ScreenWidth, height: ScreenHeight - kNavibarH - 55)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }// return NO to not become first responder
    
    func saveHistoryList(searchBar:UISearchBar){
        let exist = self.isExistSearchWord(key: searchBar.text ?? "")
        if exist == false {
            
            if let text = searchBar.text ,searchBar.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != "" {
                if historyList == nil {
                    historyList = [text]
                } else {
                    historyList?.append(text)
                }
                store?.put(historyList, withId: storeKey, intoTable: searchHistory)
                searchView.historyList = historyList
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.saveHistoryList(searchBar: searchBar)
        self.searchWords = searchBar.text ?? ""
        searchController.dismiss(animated: true, completion: nil)
        searchView.removeFromSuperview()
        requestData()
    }// called when keyboard search button pressed
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
    }// called when cancel button pressed


    func updateSearchResults(for searchController: UISearchController){
        self.searchWords = self.searchController.searchBar.text ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        
        cell!.model = self.books.count > indexPath.row ? books[indexPath.row]:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
