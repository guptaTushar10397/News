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
    
    private var docs: [Docs] = []
}

extension HomePresenter: ViewToPresenterProtocol {
    
    var numberOfRows: Int {
        docs.count
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicatorView(true)
        fetchHomeData()
    }
    
    func dataForRowAt(_ indexPath: IndexPath) -> Docs? {
        docs[indexPath.row]
    }
    
    func deleteForRowAt(_ indexPath: IndexPath) {
        let doc = docs[indexPath.row]
        interactor?.delete(doc)
    }
}

extension HomePresenter: InteractorToPresenterProtocol {
    
    func didSuccessfullyReceiveHomeModelData(_ docs: [Docs]) {
        
        self.docs = docs.sorted { doc1, doc2 in
            guard let pubDateString1 = doc1.pubDate,
                  let pubDateString2 = doc2.pubDate,
                  let date1 = DateFormatterProvider.pubDateFormatter.date(from: pubDateString1),
                  let date2 = DateFormatterProvider.pubDateFormatter.date(from: pubDateString2) else {
                return false
            }
            return date1 > date2
        }
        
        view?.showLoadingIndicatorView(false)
        view?.reloadTabelView()
    }
    
    func didFailToReceiveHomeModelData(_ error: any Error) {
        view?.showLoadingIndicatorView(false)
        fatalError("Failed to fetch data, Error: \(error.localizedDescription)")
    }
    
    func didSuccessfullyDeletedDoc(_ doc: Docs) {
        guard let index = docs.firstIndex(where: {$0 == doc}) else { return }
        docs.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        view?.deleteForRowAt(indexPath)
    }
}

private extension HomePresenter {
    
    func fetchHomeData() {
        guard let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM") else { return }
        interactor?.fetchHomeData(fromURL: url)
    }
}
