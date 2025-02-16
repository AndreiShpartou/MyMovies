//
//  PersonDetailsViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import UIKit

protocol PersonDetailsViewControllerProtocol: AnyObject {
    var presenter: PersonDetailsPresenterProtocol { get set }
}

final class PersonDetailsViewController: UIViewController, PersonDetailsViewControllerProtocol {
    var presenter: PersonDetailsPresenterProtocol

    private let personDetailsView: PersonDetailsViewProtocol

    // MARK: - Init
    init(personDetailsView: PersonDetailsViewProtocol, presenter: PersonDetailsPresenterProtocol) {
        self.personDetailsView = personDetailsView
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = personDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup
extension PersonDetailsViewController {
    private func setupViewController() {
        personDetailsView.delegate = self
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        // Setting the custom title font
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        // Custom left button
        navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
        // Custom right button
        let rightButton: UIButton = .createFavouriteButton()
        rightButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - ActionMethods
extension PersonDetailsViewController {
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

extension PersonDetailsViewController: PersonDetailsViewDelegate {
    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        presenter.didSelectGenre(genre)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        //
    }

    func didSelectMovie(movieID: Int) {
        presenter.didSelectMovie(movieID: movieID)
    }
}
