//
//  HomePresenter.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

class HomePresenter {
    weak var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
}

extension HomePresenter: ViewToPresenterProtocol {
    
}

extension HomePresenter: InteractorToPresenterProtocol {
    
}
