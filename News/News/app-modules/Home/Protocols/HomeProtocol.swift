//
//  HomeProtocol.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

protocol ViewToPresenterProtocol: AnyObject {
    var numberOfRows: Int { get }
    func viewDidLoad()
    func dataForRowAt(_ indexPath: IndexPath) -> Docs?
}

protocol PresenterToViewProtocol: AnyObject {
    func reloadTabelView()
}

protocol PresenterToRouterProtocol: AnyObject {
    
}

protocol PresenterToInteractorProtocol: AnyObject {
    func fetchHomeData(fromURL url: URL)
}

protocol InteractorToPresenterProtocol: AnyObject {
    func didSuccessfullyReceiveHomeModelData(_ homeModel: HomeDataModel)
    func didFailToReceiveHomeModelData(_ error: Error)
}

