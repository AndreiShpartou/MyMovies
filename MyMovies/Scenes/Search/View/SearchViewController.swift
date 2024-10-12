//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol SearchViewControllerProtocol {
    var presenter: SearchPresenterProtocol { get set }
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {
    var presenter: SearchPresenterProtocol
    let searchView: SearchViewProtocol

    // MARK: - Init
    init(searchView: SearchViewProtocol, presenter: SearchPresenterProtocol) {
        self.searchView = searchView
        self.presenter = presenter

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
    }
}
