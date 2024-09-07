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
            upcomingMoviesCollectionViewHandler.delegate = delegate
            genresCollectionViewHandler.delegate = delegate
            popularMoviesCollectionViewHandler.delegate = delegate
        }
    }
    var presenter: MainPresenterProtocol?

    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    // User greeting
    private let userGreetingView = UserGreetingView()
    // Search section
    private let searchBarContainerView: UIView = .createCommonView(backgroundColor: .primaryBackground)
    private let searchBar: UISearchBar = .createSearchBar(placeholder: "Search a title")
    // Upcoming movie list
    private let upcomingMoviesLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Upcoming"
    )
    private lazy var seeAllUpcomingMoviesButton: UIButton = createSeeAllButton()
    private lazy var upcomingMoviesCollectionView: UICollectionView = createUpcomingMoviesCollectionView()
    private lazy var upComingMoviesPageControl: UIPageControl = createUpcomingMoviesPageControl()
    private lazy var upcomingMoviesCollectionViewHandler = UpcomingMoviesCollectionViewHandler()

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
    func showUpcomingMovies(_ movies: [MovieProtocol]) {
        upcomingMoviesCollectionViewHandler.configure(with: movies)
        upcomingMoviesCollectionView.reloadData()

        // Set initial page for the upcoming collection
        setupUpcomingMoviesInitialPage()
    }

    func showMovieGenres(_ genres: [GenreProtocol]) {
        genresCollectionViewHandler.configure(with: genres)
        genresCollectionView.reloadData()

        setupAdditionalDefaultPreferences()
    }

    func showPopularMovies(_ movies: [MovieProtocol]) {
        popularMoviesCollectionViewHandler.configure(with: movies)
        popularMoviesCollectionView.reloadData()
    }

    func scrollToUpcomingMovieItem(_ index: Int) {
        upComingMoviesPageControl.currentPage = index

        // Update the images for the page indicators
        let unselected = Asset.PageControlIndicators.unselected.image
        let selected = Asset.PageControlIndicators.selected.image
        for pageIndex in 0..<upComingMoviesPageControl.numberOfPages {
            upComingMoviesPageControl.setIndicatorImage(unselected, forPage: pageIndex)
        }
        upComingMoviesPageControl.setIndicatorImage(selected, forPage: index)
    }

    func showError(error: Error) {
        //
    }
}

// MARK: - Setup
extension MainView {
    private func setupView() {
        backgroundColor = .primaryBackground

        addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        scrollView.showsVerticalScrollIndicator = false

        contentView.addSubviews(
            userGreetingView,
            upcomingMoviesCollectionView,
            upcomingMoviesLabel,
            seeAllUpcomingMoviesButton,
            upComingMoviesPageControl,
            genresCollectionView,
            genresLabel,
            popularMoviesLabel,
            seeAllPopularMoviesButton,
            popularMoviesCollectionView,
            searchBarContainerView
        )
        searchBarContainerView.addSubviews(searchBar)

        setupHandlers()
        setupTargets()
    }

    private func setupHandlers() {
        // Movie lists
        upcomingMoviesCollectionView.delegate = upcomingMoviesCollectionViewHandler
        upcomingMoviesCollectionView.dataSource = upcomingMoviesCollectionViewHandler
        // Genres
        genresCollectionView.delegate = genresCollectionViewHandler
        genresCollectionView.dataSource = genresCollectionViewHandler
        // Popular movies
        popularMoviesCollectionView.delegate = popularMoviesCollectionViewHandler
        popularMoviesCollectionView.dataSource = popularMoviesCollectionViewHandler
        // Scroll
        scrollView.delegate = self
    }

    private func setupTargets() {
        seeAllUpcomingMoviesButton.addTarget(self, action: #selector(didTapSeeAllUpcomingMoviesButton), for: .touchUpInside)
        seeAllPopularMoviesButton.addTarget(self, action: #selector(didTapSeeAllPopularMoviesButton), for: .touchUpInside)
    }

    private func setupAdditionalDefaultPreferences() {
        // Default selection of the first item
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        genresCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
        genresCollectionViewHandler.collectionView(genresCollectionView, didSelectItemAt: defaultIndexPath)
    }

    private func setupUpcomingMoviesInitialPage() {
        let totalItems = upcomingMoviesCollectionView.numberOfItems(inSection: 0)
        guard totalItems > 0,
            let layout = upcomingMoviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        var currentPage = 0
        var offset: CGFloat = 0
        let itemWidth = upcomingMoviesCollectionView.bounds.width * 0.8 + layout.minimumLineSpacing
        if totalItems > 2 {
            currentPage = (totalItems / 2) - 1
            offset = CGFloat(currentPage) * itemWidth - (upcomingMoviesCollectionView.bounds.width / 2) + (itemWidth / 2)
        }
        upComingMoviesPageControl.numberOfPages = totalItems
        upComingMoviesPageControl.currentPage = currentPage
        upcomingMoviesCollectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        scrollToUpcomingMovieItem(currentPage)
    }
}

// MARK: - ActionMethods
extension MainView {
    @objc
    private func didTapSeeAllUpcomingMoviesButton(_ sender: UIButton) {
        delegate?.didTapSeeAllUpcomingMoviesButton()
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
        reuseIdentifier: String,
        minimumLineSpacing: CGFloat = 8
    ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)

        return collectionView
    }

    private func createUpcomingMoviesCollectionView() -> UICollectionView {
        return createCollectionView(
            // overridden in the UpcomingMoviesCollectionViewHandler
            itemSize: CGSize(width: 50, height: 50),
            cellType: UpcomingMoviesCollectionViewCell.self,
            reuseIdentifier: "UpcomingMoviesCollectionViewCell"
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
            itemSize: CGSize(width: 150, height: 300),
            cellType: PopularMoviesCollectionViewCell.self,
            reuseIdentifier: "PopularMoviesCollectionViewCell"
        )
    }

    private func createUpcomingMoviesPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .primaryBlueAccent
        pageControl.pageIndicatorTintColor = .primaryBlueAccent
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false

        return pageControl
    }
}

// MARK: - UIScrollViewDelegate
extension MainView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let threshold: CGFloat = 60

        // Adjust opacity of the UserGreetingView
        if yOffset > 0 {
            let alphaValue = max(0, 1 - (yOffset / threshold))
            userGreetingView.alpha = alphaValue
        } else {
            userGreetingView.alpha = 1
        }

        // Keep searchBar fixed at the top
        if yOffset > (userGreetingView.frame.maxY + 8) {
            searchBarContainerView.snp.updateConstraints { make in
                make.top.greaterThanOrEqualTo(userGreetingView.snp.bottom).offset(yOffset - userGreetingView.frame.maxY)
            }
            searchBarContainerView.backgroundColor = searchBarContainerView.backgroundColor?.withAlphaComponent(0.93)
        } else {
            searchBarContainerView.snp.updateConstraints { make in
                make.top.greaterThanOrEqualTo(userGreetingView.snp.bottom).offset(8)
            }
            searchBarContainerView.backgroundColor = searchBarContainerView.backgroundColor?.withAlphaComponent(1)
        }
    }
}

// MARK: - Constraints
extension MainView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupUserGreetingSectionConstraints()
        setupSearchBarConstraints()
        setupUpcomingMoviesSectionConstraints()
        setupGenresSectionConstraints()
        setupPopularMoviesSectionConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    private func setupUserGreetingSectionConstraints() {
        userGreetingView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }
    }

    private func setupSearchBarConstraints() {
        searchBarContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.greaterThanOrEqualTo(userGreetingView.snp.bottom).offset(8)
            make.height.equalTo(60)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupUpcomingMoviesSectionConstraints() {
        // Upcoming movies section
        upcomingMoviesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(132)
        }

        seeAllUpcomingMoviesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(upcomingMoviesLabel)
        }

        upcomingMoviesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(upcomingMoviesLabel.snp.bottom).offset(16)
            make.height.equalTo(upcomingMoviesCollectionView.snp.width).multipliedBy(0.5)
        }

        upComingMoviesPageControl.snp.makeConstraints { make in
            make.centerX.equalTo(upcomingMoviesCollectionView)
            make.top.equalTo(upcomingMoviesCollectionView.snp.bottom).offset(8)
        }
    }

    private func setupGenresSectionConstraints() {
        // Genres section
        genresLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(upComingMoviesPageControl.snp.bottom).offset(24)
        }

        genresCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(genresLabel.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }

    private func setupPopularMoviesSectionConstraints() {
        // Popular movies section
        popularMoviesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(genresCollectionView.snp.bottom).offset(24)
        }

        seeAllPopularMoviesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(popularMoviesLabel)
        }

        popularMoviesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.equalTo(popularMoviesLabel.snp.bottom).offset(16)
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
    }
}
