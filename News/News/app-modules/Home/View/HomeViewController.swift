//
//  HomeViewController.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presentor: ViewToPresenterProtocol!
    
    // MARK: - IBOutlet
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setupTableView()
        presentor.viewDidLoad()
    }
}

extension HomeViewController: PresenterToViewProtocol {
    
    func reloadTabelView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainTableView.reloadData()
        }
    }
}

private extension HomeViewController {
   
    func setupTableView() {
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nibBundle), forCellReuseIdentifier: "HomeTableViewCell")
        mainTableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presentor.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        guard let doc = presentor.dataForRowAt(indexPath) else {
            return UITableViewCell()
        }
        
        cell.configureDataWithModel(doc)
        
        return cell
    }
}
