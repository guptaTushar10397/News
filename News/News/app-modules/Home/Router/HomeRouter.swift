//
//  HomeRouter.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import UIKit

class HomeRouter {
    static func createModule() -> HomeViewController {
        let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let coreDataService = CoreDataManager(container: persistentContainer)
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.coreDataService = coreDataService
        
        return view
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "HomeViewController", bundle: nil)
    }
}

extension HomeRouter: PresenterToRouterProtocol {
    
}
