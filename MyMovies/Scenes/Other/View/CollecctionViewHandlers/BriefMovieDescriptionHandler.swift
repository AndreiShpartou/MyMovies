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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BriefMovieDescriptionCollectionViewCell.identifier, for: indexPath) as? BriefMovieDescriptionCollectionViewCell else {
                fatalError("Failed to dequeue PopularMoviesCollectionViewCell")
            }
            cell.configure(with: movies[indexPath.row])

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension BriefMovieDescriptionHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !movies.isEmpty else {
            return
        }

        let movieID = movies[indexPath.row].id
        delegate?.didSelectMovie(movieID: movieID)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BriefMovieDescriptionHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemWidth: CGFloat = 150
        var itemHeight: CGFloat = 300
        if movies.isEmpty {
            itemWidth = collectionView.bounds.width
            itemHeight = collectionView.bounds.height
        }

        return CGSize(width: itemWidth, height: itemHeight)
    }
}
