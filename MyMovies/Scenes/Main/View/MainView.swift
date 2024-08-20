//
//  MainView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit
import SnapKit

final class MainView: UIView, MainViewProtocol {
    weak var delegate: MainViewDelegate? {
        didSet {
            movieListCollectionViewHandler.delegate = delegate
            genresCollectionViewHandler.delegate = delegate
            popularMoviesCollectionViewHandler.delegate = delegate
        }
    }
    var presenter: MainPresenterProtocol?

    // MARK: - Properties
    // Avatar
    private let avatarImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 20,
        image: Asset.Avatars.avatarMock.image
    )
    private let helloLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhite,
        text: "Hello, Smith"
    )
    private let favouriteButton: UIButton = .createFavouriteButton()
    // Search
    private let searchBar: UISearchBar = .createSearchBar(placeholder: "Search a title")
    // MovieList
    private let movieListsLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Collections"
    )
    private lazy var seeAllMovieListsButton: UIButton = createSeeAllButton()
    private lazy var movieListsCollectionView: UICollectionView = createMovieListCollectionView()
    private lazy var movieListCollectionViewHandler = MovieListsCollectionViewHandler()

    // Genres section
    private let genresLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Genres"
    )
    private lazy var genresCollectionView: UICollectionView = createGenresCollectionView()
    private lazy var genresCollectionViewHandler = GenresCollectionViewHandler()
    // Popular movies section
    private let popularMoviesLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Most popular"
    )
    private lazy var seeAllPopularMoviesButton: UIButton = createSeeAllButton()
    private lazy var popularMoviesCollectionView: UICollectionView = createPopularMoviesCollectionView()
    private lazy var popularMoviesCollectionViewHandler = PopularMoviesCollectionViewHandler()

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
    func showMovieLists(movieLists: [MovieList]) {
        movieListCollectionViewHandler.configure(with: movieLists)
        movieListsCollectionView.reloadData()
    }

    func showMovieGenres(genres: [GenreProtocol]) {
        genresCollectionViewHandler.configure(with: genres)
        genresCollectionView.reloadData()
    }

    func showPopularMovies(movies: [Movie]) {
        popularMoviesCollectionViewHandler.configure(with: movies)
        popularMoviesCollectionView.reloadData()
    }

    func showError(error: Error) {
        //
    }
}

// MARK: - Setup
extension MainView {
    private func setupView() {
        backgroundColor = .primaryBackground
        addSubviews(
            avatarImageView,
            helloLabel,
            favouriteButton,
            searchBar,
            movieListsCollectionView,
            movieListsLabel,
            seeAllMovieListsButton,
            genresCollectionView,
            genresLabel,
            popularMoviesLabel,
            seeAllPopularMoviesButton,
            popularMoviesCollectionView
        )

        setupHandlers()
        setupTargets()
    }

    private func setupHandlers() {
        // Movie lists
        movieListsCollectionView.delegate = movieListCollectionViewHandler
        movieListsCollectionView.dataSource = movieListCollectionViewHandler
        // Genres
        genresCollectionView.delegate = genresCollectionViewHandler
        genresCollectionView.dataSource = genresCollectionViewHandler
        // Popular movies
        popularMoviesCollectionView.delegate = popularMoviesCollectionViewHandler
        popularMoviesCollectionView.dataSource = popularMoviesCollectionViewHandler
    }

    private func setupTargets() {
        seeAllMovieListsButton.addTarget(self, action: #selector(didTapSeeAllMovieListsButton), for: .touchUpInside)
        seeAllPopularMoviesButton.addTarget(self, action: #selector(didTapSeeAllPopularMoviesButton), for: .touchUpInside)
    }
}

// MARK: - ActionMethods
extension MainView {
    @objc
    private func didTapSeeAllMovieListsButton(_ sender: UIButton) {
        delegate?.didTapSeeAllMovieListsButton()
    }

    @objc
    private func didTapSeeAllPopularMoviesButton(_ sender: UIButton) {
        delegate?.didTapSeeAllPopularMoviesButton()
    }
}

// MARK: - Helpers
extension MainView {
    private func createSeeAllButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.primaryBlueAccent, for: .normal)

        return button
    }

    private func createCollectionView(
        itemSize: CGSize,
        cellType: UICollectionViewCell.Type,
        reuseIdentifier: String
    ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = itemSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)

        return collectionView
    }

    private func createMovieListCollectionView() -> UICollectionView {
        return createCollectionView(
            itemSize: CGSize(width: 250, height: 170),
            cellType: MovieListsCollectionViewCell.self,
            reuseIdentifier: "MovieListCollectionViewCell"
        )
    }

    private func createGenresCollectionView() -> UICollectionView {
        return createCollectionView(
            itemSize: CGSize(width: 100, height: 40),
            cellType: GenreCollectionViewCell.self,
            reuseIdentifier: "GenreCollectionViewCell"
        )
    }

    private func createPopularMoviesCollectionView() -> UICollectionView {
        return createCollectionView(
            itemSize: CGSize(width: 150, height: 230),
            cellType: PopularMoviesCollectionViewCell.self,
            reuseIdentifier: "PopularMoviesCollectionViewCell"
        )
    }
}

// MARK: - Constraints
extension MainView {
    private func setupConstraints() {
        setupAvatarSectionConstraints()
        setupSearchBarConstraints()
        setupMovieListSectionConstraints()
        setupGenresSectionConstraints()
        setupPopularMoviesSectionConstraints()
    }

    private func setupAvatarSectionConstraints() {
        // Profile avatar section
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(40)
        }

        helloLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-16)
            make.centerY.equalTo(avatarImageView)
        }

        favouriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.width.height.equalTo(32)
            make.centerY.equalTo(avatarImageView)
        }
    }

    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.height.equalTo(41)
        }
    }

    private func setupMovieListSectionConstraints() {
        // Movie list section
        movieListsLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(searchBar.snp.bottom).offset(24)
        }

        seeAllMovieListsButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(movieListsLabel)
        }

        movieListsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(movieListsLabel.snp.bottom).offset(16)
            make.height.equalTo(150)
        }
    }

    private func setupGenresSectionConstraints() {
        // Genres section
        genresLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(movieListsCollectionView.snp.bottom).offset(24)
        }

        genresCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(genresLabel.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }

    private func setupPopularMoviesSectionConstraints() {
        // Popular movies section
        popularMoviesLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(genresCollectionView.snp.bottom).offset(24)
        }

        seeAllPopularMoviesButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(popularMoviesLabel)
        }

        popularMoviesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(popularMoviesLabel.snp.bottom).offset(16)
            make.height.equalTo(230)
        }
    }
}
