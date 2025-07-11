//
//  MovieDetailsViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MovieDetailsViewControllerProtocol {
    var presenter: MovieDetailsPresenterProtocol { get set }
}

final class MovieDetailsViewController: UIViewController, MovieDetailsViewControllerProtocol {
    var presenter: MovieDetailsPresenterProtocol

    private let movieDetailsView: MovieDetailsViewProtocol
    private let favouriteButton: UIButton = .createFavouriteButton()

    // MARK: - Init
    init(movieDetailsView: MovieDetailsViewProtocol, presenter: MovieDetailsPresenterProtocol) {
        self.movieDetailsView = movieDetailsView
        self.presenter = presenter

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
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
    }
}

// MARK: - Setup
extension MovieDetailsViewController {
    private func setupViewController() {
        movieDetailsView.delegate = self
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        // Setting the custom title font
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        // Custom left button
        navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
        // Custom right button
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: favouriteButton)
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
        presenter.didTapFavouriteButton()
    }
}

// MARK: - MovieDetailsInteractionDelegate
extension MovieDetailsViewController: MovieDetailsViewDelegate {

    func didFetchTitle(_ title: String?) {
        self.title = title
    }

    func didSelectReview(_ author: String?, review: String?) {
        presenter.presentReview(with: author, and: review)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        presenter.didTapSeeAllButton(listType: listType)
    }

    func didSelectMovie(movieID: Int) {
        presenter.didSelectMovie(movieID: movieID)
    }

    func didSelectPerson(personID: Int) {
        presenter.didSelectPerson(personID: personID)
    }

    func updateFavouriteButtonState(isSelected: Bool) {
        favouriteButton.isSelected = isSelected
    }

    func didTapHomePageButton(url: URL) {
        presenter.didTapHomePageButton(url: url)
    }
}
