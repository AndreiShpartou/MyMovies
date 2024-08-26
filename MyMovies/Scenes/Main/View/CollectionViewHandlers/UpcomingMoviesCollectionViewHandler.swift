//
//  MovieListsCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

final class UpcomingMoviesCollectionViewHandler: NSObject {
    weak var delegate: MainViewDelegate?

    private var movies: [MovieProtocol] = []

    // MARK: - Public
    func configure(with movies: [MovieProtocol]) {
        self.movies = movies
    }
}
// MARK: - UICollectionViewDataSource
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMoviesCollectionViewCell.identifier, for: indexPath) as? UpcomingMoviesCollectionViewCell else {
            fatalError("Failed to dequeue MovieListsCollectionViewCell")
        }
        cell.configure(with: movies[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        delegate?.didSelectMovie(movie)
    }
}
