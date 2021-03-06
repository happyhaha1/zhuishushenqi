//
//  QSCatalogViewController.swift
//  zhuishushenqi
//
//  Created caonongyun on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class QSCatalogViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate,CategoryCellItemDelegate, QSCatalogViewProtocol {

	var presenter: QSCatalogPresenterProtocol?

    var id:String? = ""
    var books:[[NSDictionary]] = []
    
    fileprivate var male:NSArray? = []
    fileprivate var female:NSArray? = []
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavibarH, width: ScreenWidth, height: ScreenHeight - kNavibarH), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 50
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(CategoryCell.self)
        if #available(iOS 11.0, *) {
            
            tableView.contentInsetAdjustmentBehavior = .never
            
            tableView.estimatedRowHeight = 0
            
            tableView.estimatedSectionHeaderHeight = 0
            
            tableView.estimatedSectionFooterHeight = 0
            
            
        }
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        presenter?.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        title = "分类"
    }
    
    //CategoryCellDelegate
    func didSelected(at:Int,cell:CategoryCell){
        let indexPath = tableView.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
        self.presenter?.didSelectAt(index: at, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let types =  self.books[indexPath.section]
        let count = ((types.count)%3 == 0 ? (types.count)/3:(types.count)/3 + 1)
        let height = count * 60
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryCell? = tableView.qs_dequeueReusableCell(CategoryCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        
        cell!.models = books[indexPath.section] as NSArray
        cell?.itemDelegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sections = ["男生","女生"]
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 200, height: 50))
        label.text = sections[section]
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(label)
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showData(models:[[NSDictionary]]){
        self.books = models
        self.tableView.reloadData()
    }

}
