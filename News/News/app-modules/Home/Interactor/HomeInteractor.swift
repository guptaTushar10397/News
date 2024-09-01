//
//  HomeInteractor.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

class HomeInteractor {
    var presenter: InteractorToPresenterProtocol?
    var coreDataService = CoreDataManager.shared
}

extension HomeInteractor: PresenterToInteractorProtocol {
    
    func addObserver() {
        coreDataService.addObserver(self)
    }
    
    func removeObserver() {
        coreDataService.removeObserver(self)
    }
    
    
    func fetchHomeData(fromURL url: URL) {
        let savedDocs = coreDataService.fetchSavedDocs()
        
        if !savedDocs.isEmpty {
            presenter?.didSuccessfullyReceiveHomeModelData(savedDocs)
        } else {
            Task {
                do {
                    let homeDataModel: HomeDataModel = try await APIManager.shared.getData(fromUrl: url)
                    
                    guard let docs = homeDataModel.response?.docs,
                          !docs.isEmpty else { return }
                    coreDataService.saveDocs(docsArray: docs)
                    presenter?.didSuccessfullyReceiveHomeModelData(docs)
                } catch {
                    presenter?.didFailToReceiveHomeModelData(error)
                }
            }
        }
    }
    
    func delete(_ doc: Docs) {
        coreDataService.delete(doc)
    }
    
    func updateDoc(_ doc: Docs) {
        coreDataService.updateDoc(doc)
    }
}

extension HomeInteractor: CoreDataManagerToInteractorProtocol {
    
    func coreDataManagerDidSuccessfullyDeletedDoc(_ doc: Docs) {
        presenter?.didSuccessfullyDeletedDoc(doc)
    }
    
    func coreDataManagerDidSuccessfullyUpdateDoc(_ doc: Docs) {
        presenter?.didSuccessfullyUpdateDoc(doc)
    }
}
