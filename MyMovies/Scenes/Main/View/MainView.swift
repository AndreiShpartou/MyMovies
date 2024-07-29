//
//  MainView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {}

protocol MainViewDelegate: AnyObject {
    func didTapSeeAllMovieListButton()
    func didTapSeeAllPopularMoviesButton()
}

final class MainView: UIView {
    weak var delegate: MainViewDelegate?
    var presenter: MainPresenterProtocol?

    // Avatar
    private let avatarImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 20
    )
    private let helloLabel: UILabel = .createLabel(
        fontSize: 20,
        weight: .bold,
        textColor: .white,
        text: "Hello, Smith"
    )
    private let favouriteButton: UIButton = .createFavouriteButton()
    // Search
    private let searchBar: UISearchBar = .createSearchBar(placeholder: "Search a title")
    // MovieList
    private lazy var movieListCollectionView: UICollectionView = createMovieListCollectionView()
    private lazy var seeAllMovieListButton: UIButton = createSeeAllButton()
    // Categories section
    private let categoriesLabel: UILabel = .createLabel(
        fontSize: 18,
        weight: .bold,
        textColor: .white,
        text: "Categories"
    )
    private let categoriesView: UIView = .createCommonView()
    // Popular movies section
    private let popularMoviesLabel: UILabel = .createLabel(
        fontSize: 18,
        weight: .bold,
        textColor: .white,
        text: "Most popular"
    )
    private lazy var seeAllPopularMoviesButton: UIButton = createSeeAllButton()
    private lazy var popularMoviesCollectionView: UICollectionView = createPopularMoviesCollectionView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension MainView {
    private func setupView() {
        setupTargets()
    }

    private func setupTargets() {
        seeAllMovieListButton.addTarget(self, action: #selector(didTapSeeAllMovieListButton), for: .touchUpInside)
        seeAllPopularMoviesButton.addTarget(self, action: #selector(didTapSeeAllPopularMoviesButton), for: .touchUpInside)
    }
}

// MARK: - ActionMethods
extension MainView {
    @objc
    private func didTapSeeAllMovieListButton(_ sender: UIButton) {
    }

    @objc
    private func didTapSeeAllPopularMoviesButton(_ sender: UIButton) {
    }
}

// MARK: - Helpers
extension MainView {
    private func createSeeAllButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.blue, for: .normal)

        return button
    }

    private func createMovieListCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 250, height: 150)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.backgroundColor = .clear

        return collectionView
    }

    private func createPopularMoviesCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 150, height: 250)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // collectionView.register(PopularMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "PopularMoviesCollectionViewCell")
        collectionView.backgroundColor = .clear

        return collectionView
    }
}

// MARK: - Constraints
extension MainView {
    private func setupConstraints() {
    }
}
