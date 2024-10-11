//
//  MovieDetailsViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    var presenter: MovieDetailsPresenterProtocol?

    private let movieDetailsView: MovieDetailsViewProtocol

    // MARK: - Init
    init(movieDetailsView: MovieDetailsViewProtocol) {
        self.movieDetailsView = movieDetailsView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = movieDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter?.viewDidLoad()
    }
}

// MARK: - Setup
extension MovieDetailsViewController {
    private func setupViewController() {
        movieDetailsView.delegate = self
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        // Setting the custom title font
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Typography.SemiBold.title,
            NSAttributedString.Key.foregroundColor: UIColor.textColorWhite
        ]
        // Custom left button
        let leftButton: UIButton = .createBackNavBarButton()
        leftButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButton
        // Custom right button
        let rightButton: UIButton = .createFavouriteButton()
        rightButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - ActionMethods
extension MovieDetailsViewController {
    @objc
    private func backButtonTapped(_ sender: UIButton) {
        // Handle back button action
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func favouriteButtonTapped(_ sender: UIButton) {
        // Handle favourite button action
    }
}

// MARK: - MovieDetailsInteractionDelegate
extension MovieDetailsViewController: MovieDetailsViewDelegate {
    func didFetchTitle(_ title: String?) {
        self.title = title
    }

    func didSelectReview(_ author: String?, review: String?) {
        presenter?.presentReview(with: author, and: review)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        presenter?.didTapSeeAllButton(listType: listType)
    }

    func didSelectMovie(movieID: Int) {
        presenter?.didSelectMovie(movieID: movieID)
    }
}
