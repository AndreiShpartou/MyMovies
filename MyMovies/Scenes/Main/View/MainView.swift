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

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        // Set search bar position by default to implement sticky behavior
        if scrollView.contentOffset.y == 0 {
            searchBarContainerView.frame.origin.y = userGreetingView.frame.maxY + 8
            searchBarContainerView.backgroundColor = searchBarContainerView.backgroundColor?.withAlphaComponent(1)
        }
    }

    // MARK: - Public
    func showUpcomingMovies(_ movies: [MovieProtocol]) {
        upcomingMoviesCollectionViewHandler.configure(with: movies)
        upcomingMoviesCollectionView.reloadData()
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

        contentView.addSubviews(
            userGreetingView,
            upcomingMoviesCollectionView,
            upcomingMoviesLabel,
            seeAllUpcomingMoviesButton,
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
        reuseIdentifier: String
    ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = itemSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)

        return collectionView
    }

    private func createUpcomingMoviesCollectionView() -> UICollectionView {
        return createCollectionView(
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
            itemSize: CGSize(width: 150, height: 230),
            cellType: PopularMoviesCollectionViewCell.self,
            reuseIdentifier: "PopularMoviesCollectionViewCell"
        )
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
            searchBarContainerView.frame.origin.y = yOffset
            searchBarContainerView.backgroundColor = searchBarContainerView.backgroundColor?.withAlphaComponent(0.93)
            searchBar.alpha = 1
        } else {
            searchBarContainerView.frame.origin.y = userGreetingView.frame.maxY + 8
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
            make.height.equalTo(60)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupUpcomingMoviesSectionConstraints() {
        // Movie list section
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
            make.height.equalTo(upcomingMoviesCollectionView.snp.width).multipliedBy(0.75)
        }
    }

    private func setupGenresSectionConstraints() {
        // Genres section
        genresLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(upcomingMoviesCollectionView.snp.bottom).offset(24)
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
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(popularMoviesLabel.snp.bottom).offset(16)
            make.height.equalTo(230)
            make.bottom.equalToSuperview()
        }
    }
}
