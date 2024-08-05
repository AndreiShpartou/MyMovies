//
//  MainView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit
import SnapKit

protocol MainViewDelegate: AnyObject {
    func didTapSeeAllCategoriesButton()
    func didTapSeeAllPopularMoviesButton()
}

final class MainView: UIView {
    weak var delegate: MainViewDelegate?
//    var presenter: MainPresenterProtocol?

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
    private lazy var movieListsCollectionView: UICollectionView = createMovieListCollectionView()
    private lazy var seeAllCategoriesButton: UIButton = createSeeAllButton()
    // Categories section
    private let categoriesLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Categories"
    )
    private lazy var categoriesCollectionView: UICollectionView = createCategoriesCollectionView()
    // Popular movies section
    private let popularMoviesLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
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
        backgroundColor = .primaryBackground
        addSubviews(
            avatarImageView,
            helloLabel,
            favouriteButton,
            searchBar,
            movieListsCollectionView,
            categoriesLabel,
            seeAllCategoriesButton,
            categoriesCollectionView,
            popularMoviesLabel,
            seeAllPopularMoviesButton,
            popularMoviesCollectionView
        )
        setupTargets()
    }

    private func setupTargets() {
        seeAllCategoriesButton.addTarget(self, action: #selector(didTapSeeAllCategoriesButton), for: .touchUpInside)
        seeAllPopularMoviesButton.addTarget(self, action: #selector(didTapSeeAllPopularMoviesButton), for: .touchUpInside)
    }
}

// MARK: - ActionMethods
extension MainView {
    @objc
    private func didTapSeeAllCategoriesButton(_ sender: UIButton) {
        delegate?.didTapSeeAllCategoriesButton()
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

    private func createCategoriesCollectionView() -> UICollectionView {
        return createCollectionView(
            itemSize: CGSize(width: 100, height: 40),
            cellType: CategoryCollectionViewCell.self,
            reuseIdentifier: "CategoryCollectionViewCell"
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
        setupCategoriesSectionConstraints()
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
        // Moive list section
        movieListsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.height.equalTo(150)
        }
        movieListsCollectionView.backgroundColor = .primarySoft // temporary
    }

    private func setupCategoriesSectionConstraints() {
        // Categories section
        categoriesLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(movieListsCollectionView.snp.bottom).offset(24)
        }

        seeAllCategoriesButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(categoriesLabel)
        }

        categoriesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(categoriesLabel.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        categoriesCollectionView.backgroundColor = .primarySoft
    }

    private func setupPopularMoviesSectionConstraints() {
        // Popular movies section
        popularMoviesLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(categoriesCollectionView.snp.bottom).offset(24)
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
        popularMoviesCollectionView.backgroundColor = .primarySoft // temporary
    }
}
