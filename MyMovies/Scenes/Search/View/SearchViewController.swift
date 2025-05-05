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

    private let searchView: SearchViewProtocol

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
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
        addShortLivedObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeShortLivedObservers()
    }
}

// MARK: - Setup
extension SearchViewController {
    private func setupViewController() {
        searchView.delegate = self
    }
}

// MARK: - ActionMethods
extension SearchViewController {
    @objc
    private func didTapActiveTabBarItem() {
        // Handle active tab bar item
        searchView.setNilValueForScrollOffset()
    }
}

// MARK: - Helpers
extension SearchViewController {
    private func addShortLivedObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapActiveTabBarItem),
            name: .activeTabBarItemRootVCTapped,
            object: nil
        )
    }

    private func removeShortLivedObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .activeTabBarItemRootVCTapped,
            object: nil
        )
    }
}

// MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {

    func didScrollUpcomingMoviesItemTo(_ index: Int) {
        //
    }

    func didSelectGenre(_ genre: GenreViewModelProtocol) {
        presenter.didSelectGenre(genre)
    }

    func didSelectMovie(movieID: Int) {
        presenter.didSelectMovie(movieID: movieID)
    }

    func didSelectPerson(personID: Int) {
        presenter.didSelectPerson(personID: personID)
    }

    func didTapSeeAllButton(listType: MovieListType) {
        presenter.didTapSeeAllButton(listType: listType)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didSearch(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Highlight the search bar
        searchBar.searchTextField.layer.borderColor = UIColor.primaryBlueAccent.cgColor
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Remove the highlight
        searchBar.searchTextField.layer.borderColor = UIColor.primarySoft.cgColor
    }
}
