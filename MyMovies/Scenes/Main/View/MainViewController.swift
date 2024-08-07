//
//  MainViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MainViewController: UIViewController, MainViewProtocol {

    var presenter: MainPresenterProtocol?

    private let mainView: UIView

    // MARK: - Init
    init(mainView: UIView) {
        self.mainView = mainView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.viewDidLoad()
    }

    func showMovieLists(movieLists: [MovieList]) {
        //
    }

    func showError(error: Error) {
        //
    }
}

// MARK: - Setup
extension MainViewController {
    private func setupViewController() {
        //
    }
}

// MARK: - MainViewDelegate
extension MainViewController: MainViewDelegate {
    func didTapSeeAllCategoriesButton() {
        // Handle "See All" action for movie list
    }

    func didTapSeeAllPopularMoviesButton() {
        // Handle "See All" action for popular movies
    }
}
