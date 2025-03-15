//
//  MovieListCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/09/2024.
//

import Foundation
import UIKit

protocol MovieListCollectionViewDelegate: AnyObject {
    func didSelectMovie(movieID: Int)
}

final class MovieListCollectionViewHandler: NSObject {
    weak var delegate: MovieListCollectionViewDelegate?

    private var movies: [MovieListItemViewModelProtocol] = []

    // MARK: - Public
    func configure(with movies: [MovieListItemViewModelProtocol]) {
        self.movies = movies
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(movies.count, 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movies.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceHolderCollectionViewCell.identifier, for: indexPath) as? PlaceHolderCollectionViewCell else {
                fatalError("Failed to dequeue PlaceHolderCollectionViewCell")
            }
            cell.configure(with: Asset.DefaultCovers.defaultPlaceholder.image, and: "There Are No Data Yet!")

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
                fatalError("Failed to dequeue MovieListCollectionViewCell")
            }
            cell.configure(with: movies[indexPath.row])

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !movies.isEmpty else {
            return
        }

        let movieID = movies[indexPath.row].id
        delegate?.didSelectMovie(movieID: movieID)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateItemSize(for: collectionView)
    }
}

// MARK: - Helpers
extension MovieListCollectionViewHandler {
    private func calculateItemSize(for collectionView: UICollectionView) -> CGSize {
        if movies.isEmpty {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        } else {
            let itemWidth = collectionView.bounds.width
            let posterWidth = collectionView.bounds.width * 0.35
            let itemHeight = posterWidth / 0.675 // 2:3 aspect ratio of movie posters

            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
}
