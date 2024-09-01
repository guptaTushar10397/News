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
    @IBOutlet private weak var mainTableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        presentor.viewDidLoad()
    }
}

extension HomeViewController: PresenterToViewProtocol {
    
    func showLoadingIndicatorView(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if show {
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.isHidden = true
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func reloadTabelView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainTableView.reloadData()
        }
    }
    
    func deleteForRowAt(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainTableView.beginUpdates()
            self.mainTableView.deleteRows(at: [indexPath], with: .automatic)
            self.mainTableView.endUpdates()
        }
    }
}

private extension HomeViewController {
    
    func setupUI() {
        self.title = "News Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        showLoadingIndicatorView(false)
    }
    
    func setupTableView() {
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nibBundle), forCellReuseIdentifier: "HomeTableViewCell")
        mainTableView.dataSource = self
        mainTableView.delegate = self
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

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self = self else { return }
            presentor.deleteForRowAt(indexPath)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite") { [weak self] _, _, _ in
            guard let self = self else { return }
            presentor.markeFavouriteForRowAt(indexPath)
        }
        
        favouriteAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
    }
}
