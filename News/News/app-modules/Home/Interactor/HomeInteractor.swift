//
//  HomeInteractor.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

class HomeInteractor {
    var presenter: InteractorToPresenterProtocol?
}

extension HomeInteractor: PresenterToInteractorProtocol {
    
    func fetchHomeData(fromURL url: URL) {
        Task {
            do {
                let homeDataModel: HomeDataModel = try await APIManager.shared.getData(fromUrl: url)
                
                guard let docs = homeDataModel.response?.docs,
                      !docs.isEmpty else { return }
                
                presenter?.didSuccessfullyReceiveHomeModelData(docs)
            } catch {
                presenter?.didFailToReceiveHomeModelData(error)
            }
        }
    }
}
