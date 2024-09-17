//
//  MovieListCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/09/2024.
//

import Foundation
import UIKit

final class MovieListCollectionViewHandler: NSObject {
    private var movies: [MovieProtocol] = []

    // MARK: - Public
    func configure(with movies: [MovieProtocol]) {
        self.movies = movies
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            fatalError("Failed to dequeue MovieListCollectionViewCell")
        }
        cell.configure(with: movies[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListCollectionViewHandler: UICollectionViewDelegate {
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
        let itemWidth = collectionView.bounds.width
        let posterWidth = collectionView.bounds.width * 0.35
        let itemHeight = posterWidth / 0.675 // 2:3 aspect ratio of movie posters

        return CGSize(width: itemWidth, height: itemHeight)
    }
}
