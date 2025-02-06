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
    private let searchBar: UISearchBar = .createSearchBar(
        placeholder: "Type title, categories, years, etc.",
        textFieldCornedRadius: 8,
        textFieldBorderWidth: 0.7
    )

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

    private let discoveredPersonsLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Persons"
    )

    private let discoveredPersonsCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 90, height: 110),
        cellTypesDict: [PersonCircleCollectionViewCell.identifier: PersonCircleCollectionViewCell.self],
        scrollDirection: .horizontal,
        minimumLineSpacing: 12
    )

    private let discoveredMoviesLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Discovered Movies"
    )

    private let discoveredMoviesCollectionView: UICollectionView = .createCommonCollectionView(
        // overridden in the MovieListCollectionViewHandler
        itemSize: CGSize(width: 50, height: 50),
        cellTypesDict: [
            MovieListCollectionViewCell.identifier: MovieListCollectionViewCell.self,
            PlaceHolderCollectionViewCell.identifier: PlaceHolderCollectionViewCell.self
        ],
        scrollDirection: .vertical,
        minimumLineSpacing: 12
    )

    private let searchResultsStackView: UIStackView = .createCommonStackView(
        axis: .vertical,
        spacing: 16,
        distribution: .fill,
        alignment: .fill
    )

    private lazy var noResultsView: UIView = createNoResultsView()
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)

    // MARK: - CollectionViewHandlers
    private lazy var genresCollectionViewHandler = GenresCollectionViewHandler()
    private lazy var discoveredPersonsCollectionViewHandler = PersonsCircleCollectionViewHandler()
    private lazy var upcomingMovieCollectionViewHandler = MovieListCollectionViewHandler()
    private lazy var recentlySearchedCollectionViewHandler = BriefMovieDescriptionHandler()
    private lazy var discoveredMoviesCollectionViewHandler = MovieListCollectionViewHandler()

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

    func showUpcomingMovies(_ movies: [MovieListItemViewModelProtocol]) {
        upcomingMovieCollectionViewHandler.configure(with: movies)
        upcomingMovieCollectionView.reloadData()
    }

    func showRecentlySearchedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        recentlySearchedCollectionViewHandler.configure(with: movies)
        recentlySearchedCollectionView.reloadData()
    }

    func showMoviesSearchResults(_ movies: [MovieListItemViewModelProtocol]) {
        guard !movies.isEmpty else {
            discoveredMoviesLabel.isHidden = true
            discoveredMoviesCollectionView.isHidden = true

            return
        }
        // Show movies collection
        discoveredMoviesCollectionViewHandler.configure(with: movies)
        discoveredMoviesCollectionView.reloadData()
        discoveredMoviesLabel.isHidden = false
        discoveredMoviesCollectionView.isHidden = false
        searchResultsStackView.isHidden = false
        searchResultsStackView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        layoutIfNeeded()
    }

    func showPersonsSearchResults(_ persons: [PersonViewModelProtocol]) {
        guard !persons.isEmpty else {
            discoveredPersonsLabel.isHidden = true
            discoveredPersonsCollectionView.isHidden = true

            return
        }
        // Show persons collection
        discoveredPersonsCollectionViewHandler.configure(with: persons)
        discoveredPersonsCollectionView.reloadData()
        discoveredPersonsCollectionView.isHidden = false
        discoveredPersonsLabel.isHidden = false
        searchResultsStackView.isHidden = false
        searchResultsStackView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = false
        layoutIfNeeded()
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
        searchResultsStackView.isHidden = true
        searchResultsStackView.isUserInteractionEnabled = false
        scrollView.isScrollEnabled = false
    }

    func showInitialElements() {
        genresLabel.isHidden = false
        genresCollectionView.isHidden = false
        upcomingMovieLabel.isHidden = false
        upcomingMovieCollectionView.isHidden = false
        recentlySearchedLabel.isHidden = false
        recentlySearchedCollectionView.isHidden = false
        discoveredPersonsLabel.isHidden = true
        discoveredPersonsCollectionView.isHidden = true
        noResultsView.isHidden = true
        searchResultsStackView.isHidden = true
        searchResultsStackView.isUserInteractionEnabled = false
        scrollView.isScrollEnabled = true
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
        addSubviews(noResultsView)
        addSubviews(searchResultsStackView)
        scrollView.addSubviews(contentView)
        scrollView.showsVerticalScrollIndicator = false

        contentView.addSubviews(
            genresLabel,
            genresCollectionView,
            upcomingMovieLabel,
            upcomingMovieCollectionView,
            recentlySearchedLabel,
            recentlySearchedCollectionView,
            loadingIndicator,
            searchBarContainerView
        )
        searchBarContainerView.addSubviews(searchBar)
        // Arrange search results subviews
        searchResultsStackView.addArrangedSubview(discoveredPersonsLabel)
        searchResultsStackView.addArrangedSubview(discoveredPersonsCollectionView)
        searchResultsStackView.addArrangedSubview(discoveredMoviesLabel)
        searchResultsStackView.addArrangedSubview(discoveredMoviesCollectionView)

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

        discoveredPersonsCollectionViewHandler.delegate = delegate
        discoveredPersonsCollectionView.delegate = discoveredPersonsCollectionViewHandler
        discoveredPersonsCollectionView.dataSource = discoveredPersonsCollectionViewHandler

        discoveredMoviesCollectionViewHandler.delegate = delegate
        discoveredMoviesCollectionView.delegate = discoveredMoviesCollectionViewHandler
        discoveredMoviesCollectionView.dataSource = discoveredMoviesCollectionViewHandler

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func updateDelegates() {
        genresCollectionViewHandler.delegate = delegate
        upcomingMovieCollectionViewHandler.delegate = delegate
        recentlySearchedCollectionViewHandler.delegate = delegate
        discoveredPersonsCollectionViewHandler.delegate = delegate
        discoveredMoviesCollectionViewHandler.delegate = delegate
        searchBar.delegate = delegate
    }

    private func setupAdditionalDefaultPreferences() {
        // Default selection of the first item
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        genresCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
        genresCollectionViewHandler.collectionView(genresCollectionView, didSelectItemAt: defaultIndexPath)
    }
}

// MARK: - Action Methods
extension SearchView {
    @objc private func viewWasTapped() {
        endEditing(true)
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
            numberOfLines: 0,
            textAlignment: .center,
            textColor: .textColorWhite,
            text: "We Are Sorry, We Can't Find The Movie :("
        )

        view.addSubviews(captionLabel, imageView)

        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(150)
        }

        captionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.top).offset(-16)
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
    }

    private func setupOtherConstraints() {
        noResultsView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(76)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        searchResultsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(76)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }

        discoveredPersonsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
    }
}
