//
//  HomeInteractor.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

class HomeInteractor {
    var presenter: InteractorToPresenterProtocol?
    var coreDataService: CoreDataManagerProtocol?
}

extension HomeInteractor: PresenterToInteractorProtocol {
    
    func fetchHomeData(fromURL url: URL) {
        if let savedDocs = coreDataService?.fetchSavedDocs(),
           !savedDocs.isEmpty {
            presenter?.didSuccessfullyReceiveHomeModelData(savedDocs)
        } else {
            Task {
                do {
                    let homeDataModel: HomeDataModel = try await APIManager.shared.getData(fromUrl: url)
                    
                    guard let docs = homeDataModel.response?.docs,
                          !docs.isEmpty else { return }
                    coreDataService?.saveDocs(docsArray: docs)
                    presenter?.didSuccessfullyReceiveHomeModelData(docs)
                } catch {
                    presenter?.didFailToReceiveHomeModelData(error)
                }
            }
        }
    }
}
