//
//  SearchView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit
import SnapKit

final class SearchView: UIView, SearchViewProtocol {
    weak var delegate: SearchViewDelegate? {
        didSet {
            setupDelegates()
        }
    }

    // MARK: - UI Components
    private let searchBar: UISearchBar = .createSearchBar(placeholder: "Type title, categories, years, etc.")

    private let genresLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Genres"
    )

    private let genresCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 100, height: 40),
        cellTypesDict: [GenreCollectionViewCell.identifier: GenreCollectionViewCell.self]
    )

    private let upcomingMovieLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Upcoming Movie"
    )

    private let upcomingMovieCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 150, height: 300),
        cellTypesDict: [UpcomingMoviesCollectionViewCell.identifier: UpcomingMoviesCollectionViewCell.self]
    )

    private let recentlySearchedLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Recently Searched"
    )

    private let recentlySearchedCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 150, height: 300),
        cellTypesDict: [BriefMovieDescriptionCollectionViewCell.identifier: BriefMovieDescriptionCollectionViewCell.self]
    )

    private lazy var noResultsView: UIView = createNoResultsView()
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)

    // MARK: - CollectionViewHandlers
    private lazy var genresCollectionViewHandler = GenresCollectionViewHandler()
    private lazy var upcomingMovieCollectionViewHandler = UpcomingMoviesCollectionViewHandler()
    private lazy var recentlySearchedCollectionViewHandler = BriefMovieDescriptionHandler()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchViewProtocol
    func showGenres(_ genres: [GenreViewModelProtocol]) {
        genresCollectionViewHandler.configure(with: genres)
        genresCollectionView.reloadData()
    }

    func showUpcomingMovie(_ movie: UpcomingMovieViewModelProtocol) {
        upcomingMovieCollectionViewHandler.configure(with: [movie])
        upcomingMovieCollectionView.reloadData()
    }

    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        recentlySearchedCollectionViewHandler.configure(with: movies)
        recentlySearchedCollectionView.reloadData()
    }

    func showPopularMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        recentlySearchedCollectionViewHandler.configure(with: movies)
        recentlySearchedCollectionView.reloadData()
    }

    func showSearchResults(_ movies: [BriefMovieListItemViewModelProtocol]) {
        hideAllElements()
        recentlySearchedCollectionViewHandler.configure(with: movies)
        recentlySearchedCollectionView.reloadData()
        recentlySearchedLabel.text = "Search Results"
        recentlySearchedLabel.isHidden = false
        recentlySearchedCollectionView.isHidden = false
    }

    func showPersonResults(_ persons: [PersonViewModelProtocol], relatedMovies: [BriefMovieListItemViewModelProtocol]) {
        hideAllElements()
        // Implement person collection view and related movies collection view
    }

    func showNoResults() {
        hideAllElements()
        noResultsView.isHidden = false
    }

    func hideAllElements() {
        genresLabel.isHidden = true
        genresCollectionView.isHidden = true
        upcomingMovieLabel.isHidden = true
        upcomingMovieCollectionView.isHidden = true
        recentlySearchedLabel.isHidden = true
        recentlySearchedCollectionView.isHidden = true
        noResultsView.isHidden = true
    }

    func showInitialElements() {
        genresLabel.isHidden = false
        genresCollectionView.isHidden = false
        upcomingMovieLabel.isHidden = false
        upcomingMovieCollectionView.isHidden = false
        recentlySearchedLabel.isHidden = false
        recentlySearchedCollectionView.isHidden = false
        noResultsView.isHidden = true
    }

    func showLoading() {
        loadingIndicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
    }

    func showError(error: Error) {
        guard let viewController = parentViewController else {
            return
        }

        // Present an alert to the user
        let alert = getGlobalAlertController(for: error.localizedDescription)
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup
extension SearchView {
    private func setupView() {
        backgroundColor = .primaryBackground

        addSubviews(
            searchBar,
            genresLabel,
            genresCollectionView,
            upcomingMovieLabel,
            upcomingMovieCollectionView,
            recentlySearchedLabel,
            recentlySearchedCollectionView,
            noResultsView,
            loadingIndicator
        )

        // Initially hide noResultsView
        noResultsView.isHidden = true

        setupDelegates()
        setupHandlers()
    }

    private func setupDelegates() {
//        genresCollectionViewHandler.delegate = delegate
//        upcomingMovieCollectionView.delegate = delegate
//        recentlySearchedCollectionView.delegate = delegate
        searchBar.delegate = delegate
    }

    private func setupHandlers() {
//        genresCollectionViewHandler.delegate = delegate
//        genresCollectionView.delegate = genresCollectionViewHandler
//        genresCollectionView.dataSource = genresCollectionViewHandler
//        
//        upcomingMovieCollectionViewHandler.delegate = delegate
//        upcomingMovieCollectionView.delegate = upcomingMovieCollectionViewHandler
//        upcomingMovieCollectionView.dataSource = upcomingMovieCollectionViewHandler
//        
//        recentlySearchedHandler.delegate = delegate
//        recentlySearchedCollectionView.delegate = recentlySearchedHandler
//        recentlySearchedCollectionView.dataSource = recentlySearchedHandler
    }
}

// MARK: - Helpers
extension SearchView {
    private func createNoResultsView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        // Image
        let imageView = UIImageView(image: Asset.Search.noResults.image)
        imageView.contentMode = .scaleAspectFit
        // Label
        let captionLabel: UILabel = .createLabel(
            font: Typography.Medium.largeTitle,
            textAlignment: .center,
            textColor: .textColorWhite,
            text: "We Are Sorry, We Can't Find The Movie :("
        )

        view.addSubviews(imageView, captionLabel)

        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(150)
        }

        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }

        return view
    }
}

// MARK: - Constraints
extension SearchView {
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        genresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }

        upcomingMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(genresCollectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        upcomingMovieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(upcomingMovieLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        recentlySearchedLabel.snp.makeConstraints { make in
            make.top.equalTo(upcomingMovieCollectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        recentlySearchedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentlySearchedLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }

        noResultsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
