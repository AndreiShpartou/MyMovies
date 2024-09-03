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

// MARK: - UICollectionViewDelegateFlowLayout
extension UpcomingMoviesCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.8, height: collectionView.bounds.height)
    }
}

// MARK: - Section Heading
extension UpcomingMoviesCollectionViewHandler: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = scrollView as? UICollectionView,
              let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let targetOffset = targetContentOffset.pointee.x
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth * 0.8 + layout.minimumLineSpacing
        var index: CGFloat = targetOffset / itemWidth // unrounded index
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
        // Update the page control
        delegate?.didScrollUpcomingMoviesItemTo(Int(index))
    }
}
