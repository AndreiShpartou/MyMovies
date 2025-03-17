//
//  WishlistView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit
import SnapKit

final class WishlistView: UIView, WishlistViewProtocol {
    weak var delegate: WishlistViewDelegate?

    // MARK: - UIComponents
    private let collectionView: UICollectionView = .createCommonCollectionView(
        // Will be redefined in handler
        itemSize: CGSize(width: 100, height: 200),
        cellTypesDict: [
            WishlistCollectionViewCell.identifier: WishlistCollectionViewCell.self,
            PlaceHolderCollectionViewCell.identifier: PlaceHolderCollectionViewCell.self
        ],
        minimumLineSpacing: 16
    )

    private lazy var collectionViewHandler = WishlistCollectionViewHandler()

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
    func showMovies(_ movies: [WishlistItemViewModelProtocol]) {
        collectionViewHandler.configure(with: movies)
        collectionView.reloadData()
    }

    func showError(error: Error) {
    }
}

// MARK: - Setup
extension WishlistView {
    private func setupView() {
        backgroundColor = .primaryBackground
    }
}

// MARK: - Constraints
extension WishlistView {
    private func setupConstraints() {
    }
}
