//
//  WishlistView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit
import SnapKit

final class WishlistView: UIView, WishlistViewProtocol {
    weak var delegate: WishlistViewDelegate? {
        didSet {
            updateDelegates()
        }
    }

    // MARK: - UIComponents
    private let collectionView: UICollectionView = .createCommonCollectionView(
        // Will be redefined in handler
        itemSize: CGSize(width: 100, height: 150),
        cellTypesDict: [
            WishlistCollectionViewCell.identifier: WishlistCollectionViewCell.self,
            PlaceHolderCollectionViewCell.identifier: PlaceHolderCollectionViewCell.self
        ],
        scrollDirection: .vertical,
        minimumLineSpacing: 12
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

    func removeMovie(at index: Int) {
        collectionViewHandler.removeItem(at: index)

        // Reload data to show placeholder
        if index == 0, collectionView.numberOfItems(inSection: 0) == 1 {
            collectionView.reloadData()

            return
        }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }

    func showError(error: Error) {
    }
}

// MARK: - Setup
extension WishlistView {
    private func setupView() {
        backgroundColor = .primaryBackground

        setupHandlers()
    }

    private func setupHandlers() {
        collectionView.delegate = collectionViewHandler
        collectionView.dataSource = collectionViewHandler
    }

    private func updateDelegates() {
        collectionViewHandler.delegate = delegate
    }
}

// MARK: - Constraints
extension WishlistView {
    private func setupConstraints() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
