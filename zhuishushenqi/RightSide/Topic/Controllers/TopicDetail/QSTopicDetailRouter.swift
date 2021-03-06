//
//  QSTopicDetailRouter.swift
//  zhuishushenqi
//
//  Created caonongyun on 2017/4/20.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class QSTopicDetailRouter: QSTopicDetailWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(id:String) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSTopicDetailViewController(nibName: nil, bundle: nil)
        let interactor = QSTopicDetailInteractor()
        
        let router = QSTopicDetailRouter()
        let presenter = QSTopicDetailPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        interactor.id = id
        
        return view
    }
    
    func presentDetail(indexPath:IndexPath,models:[TopicDetailModel]){
        if indexPath.section > 0 {
            let model = models[indexPath.section - 1]
            viewController?.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: model.book._id), animated: true)
        }
    }
}
