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
            updateDelegates()
        }
    }

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchBarContainerView: UIView = .createCommonView(backgroundColor: .primaryBackground)
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

    private let personsLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Persons"
    )

    private let personsCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 50, height: 50),
        cellTypesDict: [PersonCircleCollectionViewCell.identifier: PersonCircleCollectionViewCell.self],
        scrollDirection: .horizontal
    )

    private let upcomingMovieLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Upcoming Movie"
    )

    private let upcomingMovieCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 150, height: 300),
        cellTypesDict: [
            MovieListCollectionViewCell.identifier: MovieListCollectionViewCell.self,
            PlaceHolderCollectionViewCell.identifier: PlaceHolderCollectionViewCell.self
        ]
    )

    private let recentlySearchedLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Recently Searched"
    )

    private let recentlySearchedCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 150, height: 300),
        cellTypesDict: [
            BriefMovieDescriptionCollectionViewCell.identifier: BriefMovieDescriptionCollectionViewCell.self,
            PlaceHolderCollectionViewCell.identifier: PlaceHolderCollectionViewCell.self
        ]
    )

    private lazy var noResultsView: UIView = createNoResultsView()
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)

    // MARK: - CollectionViewHandlers
    private lazy var genresCollectionViewHandler = GenresCollectionViewHandler()
    private lazy var personsCollectionViewHandler = PersonsCircleCollectionViewHandler()
    private lazy var upcomingMovieCollectionViewHandler = MovieListCollectionViewHandler()
    private lazy var recentlySearchedCollectionViewHandler = BriefMovieDescriptionHandler()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SearchViewProtocol
    func showGenres(_ genres: [GenreViewModelProtocol]) {
        genresCollectionViewHandler.configure(with: genres)
        genresCollectionView.reloadData()

        setupAdditionalDefaultPreferences()
    }

    func showUpcomingMovie(_ movie: MovieListItemViewModelProtocol) {
        upcomingMovieCollectionViewHandler.configure(with: [movie])
        upcomingMovieCollectionView.reloadData()
    }

    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
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
        // Show persons collection
        personsCollectionViewHandler.configure(with: persons)
        personsCollectionView.reloadData()
        personsLabel.isHidden = false
        personsCollectionView.isHidden = false
        // Show related movie
        showSearchResults(relatedMovies)
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
        personsLabel.isHidden = true
        personsCollectionView.isHidden = true
    }

    func showInitialElements() {
        genresLabel.isHidden = false
        genresCollectionView.isHidden = false
        upcomingMovieLabel.isHidden = false
        upcomingMovieCollectionView.isHidden = false
        recentlySearchedLabel.isHidden = false
        recentlySearchedCollectionView.isHidden = false
        personsLabel.isHidden = true
        personsCollectionView.isHidden = true
        noResultsView.isHidden = true
    }

    func showLoading() {
        loadingIndicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
    }

    func showError(_ error: Error) {
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

        addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        scrollView.showsVerticalScrollIndicator = false

        contentView.addSubviews(
            genresLabel,
            genresCollectionView,
            personsLabel,
            personsCollectionView,
            upcomingMovieLabel,
            upcomingMovieCollectionView,
            recentlySearchedLabel,
            recentlySearchedCollectionView,
            noResultsView,
            loadingIndicator,
            searchBarContainerView
        )
        searchBarContainerView.addSubviews(searchBar)

        setupHandlers()
        showInitialElements()
    }

    private func setupHandlers() {
        searchBar.delegate = delegate
        scrollView.delegate = self

        genresCollectionViewHandler.delegate = delegate
        genresCollectionView.delegate = genresCollectionViewHandler
        genresCollectionView.dataSource = genresCollectionViewHandler

        upcomingMovieCollectionViewHandler.delegate = delegate
        upcomingMovieCollectionView.delegate = upcomingMovieCollectionViewHandler
        upcomingMovieCollectionView.dataSource = upcomingMovieCollectionViewHandler

        recentlySearchedCollectionViewHandler.delegate = delegate
        recentlySearchedCollectionView.delegate = recentlySearchedCollectionViewHandler
        recentlySearchedCollectionView.dataSource = recentlySearchedCollectionViewHandler
    }

    private func updateDelegates() {
        genresCollectionViewHandler.delegate = delegate
        upcomingMovieCollectionViewHandler.delegate = delegate
        recentlySearchedCollectionViewHandler.delegate = delegate
    }

    private func setupAdditionalDefaultPreferences() {
        // Default selection of the first item
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        genresCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
        genresCollectionViewHandler.collectionView(genresCollectionView, didSelectItemAt: defaultIndexPath)
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

// MARK: - UIScrollViewDelegate
extension SearchView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 8 {
            searchBarContainerView.snp.updateConstraints { make in
                make.top.greaterThanOrEqualToSuperview().offset(yOffset)
            }
        } else {
            searchBarContainerView.snp.updateConstraints { make in
                make.top.greaterThanOrEqualToSuperview().offset(8)
            }
        }
    }
}

// MARK: - Constraints
extension SearchView {
    private func setupConstraints() {
        setupScrollViewConstraints()
        setupSearchBarConstraints()
        setupGenresSectionConstraints()
        setupCollectionViewsConstraints()
        setupOtherConstraints()
    }

    private func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    private func setupSearchBarConstraints() {
        searchBarContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(8)
            make.height.equalTo(60)
        }

        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupGenresSectionConstraints() {
        genresLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(76)
        }

        genresCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(genresLabel.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
    }

    private func setupCollectionViewsConstraints() {
        upcomingMovieLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(genresCollectionView.snp.bottom).offset(16)
        }

        upcomingMovieCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(upcomingMovieLabel.snp.bottom).offset(16)
            make.height.equalTo(200)
        }

        recentlySearchedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(upcomingMovieCollectionView.snp.bottom).offset(24)
        }

        recentlySearchedCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(recentlySearchedLabel.snp.bottom).offset(16)
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(-16)
        }

        personsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(recentlySearchedCollectionView.snp.bottom).offset(16)
        }

        personsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(personsLabel.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
    }

    private func setupOtherConstraints() {
        noResultsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.center.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
