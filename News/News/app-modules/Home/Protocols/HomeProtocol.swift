//
//  HomeProtocol.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

protocol ViewToPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol PresenterToViewProtocol: AnyObject {
    
}

protocol PresenterToRouterProtocol: AnyObject {
    
}

protocol PresenterToInteractorProtocol: AnyObject {
    func fetchData(fromURL url: URL)
}

protocol InteractorToPresenterProtocol: AnyObject {
    func didSuccessfullyReceiveHomeModelData(_ homeModel: HomeDataModel)
    func didFailToReceiveHomeModelData(_ error: Error)
}

