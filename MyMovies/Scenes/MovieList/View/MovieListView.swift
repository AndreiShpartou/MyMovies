//
//  MovieListView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class MovieListView: UIView, MovieListViewProtocol {
    weak var delegate: MovieListViewDelegate? {
        didSet {
            updateDelegates()
        }
    }
    var presenter: MovieListPresenterProtocol?

    // MARK: - UIComponents
    // Genres collection
    private let genresCollection: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 100, height: 40),
        cellType: GenreCollectionViewCell.self,
        reuseIdentifier: GenreCollectionViewCell.identifier
    )
    private lazy var genresCollectionHandler = GenresCollectionViewHandler()
    // Movie list collection
    private let movieListCollection: UICollectionView = .createCommonCollectionView(
        // overridden in the MovieListCollectionViewHandler
        itemSize: CGSize(width: 50, height: 50),
        cellType: MovieListCollectionViewCell.self,
        reuseIdentifier: MovieListCollectionViewCell.identifier,
        scrollDirection: .vertical,
        minimumLineSpacing: 12
    )
    private lazy var moviesCollectionViewHandler = MovieListCollectionViewHandler()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func showMovieGenres(_ genres: [GenreViewModelProtocol]) {
        genresCollectionHandler.configure(with: genres)
        genresCollection.reloadData()

        setupAdditionalDefaultPreferences()
    }

    func showMovieList(_ movies: [MovieProtocol]) {
        moviesCollectionViewHandler.configure(with: movies)
        movieListCollection.reloadData()
    }
}

// MARK: - Setup
extension MovieListView {
    private func setupView() {
        backgroundColor = .primaryBackground
        addSubviews(genresCollection, movieListCollection)

        setupHandlers()
    }

    private func setupHandlers() {
        // movies
        movieListCollection.delegate = moviesCollectionViewHandler
        movieListCollection.dataSource = moviesCollectionViewHandler
        // genres
        genresCollection.delegate = genresCollectionHandler
        genresCollection.dataSource = genresCollectionHandler
    }

    private func updateDelegates() {
        genresCollectionHandler.delegate = delegate
    }

    private func setupAdditionalDefaultPreferences() {
        // Default selection of the first item
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        genresCollection.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
        genresCollectionHandler.collectionView(genresCollection, didSelectItemAt: defaultIndexPath)
    }
}

// MARK: - Constraints
extension MovieListView {
    private func setupConstraints() {
        genresCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }

        movieListCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(genresCollection.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
