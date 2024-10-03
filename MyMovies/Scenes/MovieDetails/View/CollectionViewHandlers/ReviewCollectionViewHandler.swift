//
//  ReviewCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/10/2024.
//

import UIKit

final class ReviewCollectionViewHandler: NSObject {
    weak var delegate: MovieDetailsInteractionDelegate?

    private var reviews: [ReviewViewModelProtocol] = []

    // MARK: - Public
    func configure(with reviews: [ReviewViewModelProtocol]) {
        self.reviews = reviews
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell else {
            fatalError("Failed to dequeue PersonCollectionViewCell")
        }
        cell.configure(with: reviews[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ReviewCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectReview(reviews[indexPath.row].author, review: reviews[indexPath.row].review)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReviewCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width * 0.8
        let itemHeight = collectionView.bounds.height

        return CGSize(width: itemWidth, height: itemHeight)
    }
}
