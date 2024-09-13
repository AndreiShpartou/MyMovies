//
//  MovieListView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

class MovieListView: UIView, MovieListViewProtocol {
    weak var delegate: MovieListViewDelegate?
    var presenter: MovieListPresenterProtocol?

    // MARK: - UIComponents
    private let movieListCollection: UICollectionView = .createCommonCollectionView(
        // overridden in the MovieListCollectionViewHandler
        itemSize: CGSize(width: 50, height: 50),
        cellType: MovieListCollectionViewCell.self,
        reuseIdentifier: MovieListCollectionViewCell.identifier,
        scrollDirection: .vertical,
        minimumLineSpacing: 12
    )

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
extension MovieListView {
    private func setupView() {
        addSubviews(movieListCollection)
    }
}

// MARK: - Constraints
extension MovieListView {
    private func setupConstraints() {
        movieListCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
