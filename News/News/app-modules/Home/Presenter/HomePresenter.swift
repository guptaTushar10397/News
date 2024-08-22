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
    
    private var homeDataModel: HomeDataModel = HomeDataModel()
}

extension HomePresenter: ViewToPresenterProtocol {
    
    func viewDidLoad() {
        fetchData()
    }
}

extension HomePresenter: InteractorToPresenterProtocol {
    
    func didSuccessfullyReceiveHomeModelData(_ homeModel: HomeDataModel) {
        self.homeDataModel = homeModel
        print("")
    }
    
    func didFailToReceiveHomeModelData(_ error: any Error) {
        fatalError("Failed to fetch data, Error: \(error.localizedDescription)")
    }
}

private extension HomePresenter {
    
    func fetchData() {
        guard let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM") else { return }
        interactor?.fetchData(fromURL: url)
    }
}
