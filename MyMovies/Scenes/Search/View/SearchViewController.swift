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
    }
}

// MARK: - Setup
extension SearchViewController {
    private func setupViewController() {
        searchView.delegate = self
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

    func didSelectPerson(person: PersonViewModelProtocol) {
        //
    }

    func didTapSeeAllButton() {
        presenter.didTapSeeAllButton()
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
