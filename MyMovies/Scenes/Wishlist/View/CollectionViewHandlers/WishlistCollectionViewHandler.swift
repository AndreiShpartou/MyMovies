//
//  WishlistCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/03/2025.
//

import Foundation
import UIKit

protocol WishlistCollectionViewHandlerDelegate: AnyObject {
    func didSelectMovie(movieID: Int)
    func didTapRemoveButton(for movieID: Int)
}

final class WishlistCollectionViewHandler: NSObject {
    weak var delegate: WishlistCollectionViewHandlerDelegate?

    private var movies: [WishlistItemViewModelProtocol] = []

    // MARK: - Public
    func configure(with movies: [WishlistItemViewModelProtocol]) {
        self.movies = movies
    }

    func removeItem(at index: Int) {
        guard index < movies.count else { return }
        movies.remove(at: index)
    }
}

// MARK: - UICollectionViewDataSource
extension WishlistCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(movies.count, 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movies.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceHolderCollectionViewCell.identifier, for: indexPath) as? PlaceHolderCollectionViewCell else {
                fatalError("Failed to dequeue PlaceHolderCollectionViewCell")
            }
            cell.configure(
                with: Asset.DefaultCovers.defaultPlaceholder.image,
                and: "There Are No Data Yet!",
                backgroundColor: .primaryBackground
            )

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishlistCollectionViewCell.identifier, for: indexPath) as? WishlistCollectionViewCell else {
                fatalError("Failed to dequeue WishlistCollectionViewCell")
            }
            cell.configure(with: movies[indexPath.row])
            cell.delegate = self

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension WishlistCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !movies.isEmpty else {
            return
        }

        let movieID = movies[indexPath.row].id
        delegate?.didSelectMovie(movieID: movieID)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishlistCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = collectionView.bounds.width
        let itemHeight: CGFloat = movies.isEmpty ? collectionView.bounds.height : collectionView.bounds.width * 0.35

        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension WishlistCollectionViewHandler: WishlistCollectionViewCellDelegate {
    func didTapRemoveButton(for movieID: Int) {
        delegate?.didTapRemoveButton(for: movieID)
    }
}
