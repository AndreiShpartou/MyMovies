//
//  BriefMovieDescriptionHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

protocol BriefMovieDescriptionHandlerDelegate: AnyObject {
    func didSelectMovie(movieID: Int)
}

final class BriefMovieDescriptionHandler: NSObject {
    weak var delegate: BriefMovieDescriptionHandlerDelegate?

    private var movies: [BriefMovieListItemViewModelProtocol] = []

    // MARK: - Public
    func configure(with movies: [BriefMovieListItemViewModelProtocol]) {
        self.movies = movies
    }
}

// MARK: - UICollectionViewDataSource
extension BriefMovieDescriptionHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BriefMovieDescriptionCollectionViewCell.identifier, for: indexPath) as? BriefMovieDescriptionCollectionViewCell else {
            fatalError("Failed to dequeue PopularMoviesCollectionViewCell")
        }
        cell.configure(with: movies[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BriefMovieDescriptionHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieID = movies[indexPath.row].id
        delegate?.didSelectMovie(movieID: movieID)
    }
}
