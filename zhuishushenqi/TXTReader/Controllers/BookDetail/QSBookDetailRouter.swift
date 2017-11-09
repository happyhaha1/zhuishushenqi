//
//  QSBookDetailRouter.swift
//  zhuishushenqi
//
//  Created Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class QSBookDetailRouter: QSBookDetailWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(id:String) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSBookDetailViewController(nibName: nil, bundle: nil)
        view.id = id
        let interactor = QSBookDetailInteractor()
        let router = QSBookDetailRouter()
        let presenter = QSBookDetailPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func presentReading(model:[ResourceModel],booDetail:BookDetail){
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        DZMReadParser.ParserLocalURL(url: url!) {[weak self] (readModel) in
            
            let readController = DZMReadController()
            
            readController.readModel = readModel
            
            self?.viewController?.navigationController?.pushViewController(readController, animated: true)
        }
    }
    
    func presentComment(model:BookComment){
        viewController?.navigationController?.pushViewController(QSBookCommentRouter.createModule(model: model), animated: true)
    }
    
    func presentTopic(model:QSBookList){
        viewController?.navigationController?.pushViewController(QSTopicDetailRouter.createModule(id: model.id), animated: true)
    }
    
    func presentSelf(model:Book){
        let id = model._id ?? ""
        viewController?.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: id), animated: true)
    }
    
    func presentCommunity(model: BookDetail) {
        viewController?.navigationController?.pushViewController(QSCommunityRouter.createModule(model: model), animated: true)
    }
    
    func presentInterestedView(recList:[Book]){
        let interestedVC = QSInterestedViewController()
        interestedVC.books = recList
        viewController?.navigationController?.pushViewController(interestedVC, animated: true)
    }
}
