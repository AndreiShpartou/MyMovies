//
//  MovieListsCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

final class MovieListsCollectionViewHandler: NSObject {
    weak var delegate: MainViewDelegate?

    private var movieLists: [MovieList] = []

    // MARK: - Public
    func configure(with movieLists: [MovieList]) {
        self.movieLists = movieLists
    }
}
// MARK: - UICollectionViewDataSource
extension MovieListsCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieLists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListsCollectionViewCell.identifier, for: indexPath) as? MovieListsCollectionViewCell else {
            fatalError("Failed to dequeue MovieListsCollectionViewCell")
        }
        cell.configure(with: movieLists[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListsCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieList = movieLists[indexPath.row]
        delegate?.didSelectMovieList(movieList)
    }
}
