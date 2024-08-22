//
//  HomeViewController.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presentor:ViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentor?.viewDidLoad()
    }
}

extension HomeViewController: PresenterToViewProtocol {
    
}
