//
//  MovieListsCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit
import Kingfisher

protocol UpcomingMoviesCollectionViewDelegate: AnyObject {
    func didSelectMovie(movieID: Int)
    func didScrollUpcomingMoviesItemTo(_ index: Int)
}

final class UpcomingMoviesCollectionViewHandler: NSObject {
    weak var delegate: UpcomingMoviesCollectionViewDelegate?

    private var movies: [UpcomingMovieViewModelProtocol] = []

    // MARK: - Public
    func configure(with movies: [UpcomingMovieViewModelProtocol]) {
        self.movies = movies
    }
}

// MARK: - UICollectionViewDataSourcex
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(movies.count, 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movies.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceHolderCollectionViewCell.identifier, for: indexPath) as? PlaceHolderCollectionViewCell else {
                fatalError("Failed to dequeue PlaceHolderCollectionViewCell")
            }
            cell.configure(with: Asset.DefaultCovers.defaultPlaceholder.image, and: "There Is No Movie Yet!")

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMoviesCollectionViewCell.identifier, for: indexPath) as? UpcomingMoviesCollectionViewCell else {
                fatalError("Failed to dequeue MovieListsCollectionViewCell")
            }
            cell.configure(with: movies[indexPath.row])

            return cell
        }
    }
}

// MARK: - UICollectionViewDataSourcePefetching
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urlsToPrefetch: [URL] = indexPaths.flatMap {
            let movie = movies[$0.row]
            return [movie.backdropURL, movie.posterURL].compactMap { $0 }
        }

        ImagePrefetcher(urls: urlsToPrefetch).start()
    }
}

// MARK: - UICollectionViewDelegate
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieID = movies[indexPath.row].id
        delegate?.didSelectMovie(movieID: movieID)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateItemSize(for: collectionView)
    }
}

// MARK: - Section Heading
extension UpcomingMoviesCollectionViewHandler: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = calculateTargetIndex(for: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        // Update the page control
        delegate?.didScrollUpcomingMoviesItemTo(index)
    }
}

// MARK: - Helpers
extension UpcomingMoviesCollectionViewHandler {
    private func calculateItemSize(for collectionView: UICollectionView) -> CGSize {
        var itemWidth = collectionView.bounds.width * 0.8
        let itemHeight = collectionView.bounds.height
        if movies.isEmpty {
            itemWidth = collectionView.bounds.width
        }

        return CGSize(width: itemWidth, height: itemHeight)
    }

    private func calculateTargetIndex(for scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Int {
        var index: CGFloat = 0
        guard let collectionView = scrollView as? UICollectionView,
              let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return Int(index)
        }

        let targetOffset = targetContentOffset.pointee.x
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth * 0.8 + layout.minimumLineSpacing
        index = targetOffset / itemWidth // unrounded index
        let velocityX = velocity.x
        if velocity.x == 0 {
            // Set the same page
            index = round(index)
        }
        if velocityX > 0 {
            // Get the next page
            index = ceil(index)
        }
        if velocityX < 0 {
            // Get the previous page
            index = floor(index)
        }

        // Calculate the new offset
        var newOffset = index * itemWidth - (collectionViewWidth / 2) + (itemWidth / 2)
        // Ensure the offset is withing the valid range
        newOffset = max(0, min(newOffset, collectionView.contentSize.width - collectionViewWidth))
        // Update the targetContentOffset to snap the nearest item
        targetContentOffset.pointee = CGPoint(x: newOffset, y: collectionView.contentOffset.y)

        return Int(index)
    }
}
