//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class SearchViewController: UIViewController, SearchViewProtocol {
    var presenter: SearchPresenterProtocol?

    let searchView: UIView
    
    // MARK: - Init
    init(searchView: UIView) {
        self.searchView = searchView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

}

// MARK: - Setup
extension SearchViewController {
    private func setupViewController() {
        title = "Search"
    }
}
