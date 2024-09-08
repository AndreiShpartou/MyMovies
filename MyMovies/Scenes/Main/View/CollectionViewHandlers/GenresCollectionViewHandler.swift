//
//  GenresCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

final class GenresCollectionViewHandler: NSObject {
    weak var delegate: MainViewDelegate?

    private var genres: [GenreProtocol] = []
    private var selectedIndex: IndexPath?

    // MARK: - Public
    func configure(with genres: [GenreProtocol]) {
        // Add the "All" genre at the start
        let allGenre = Movie.Genre(id: nil, name: "All")
        self.genres = [allGenre] + genres
    }
}

// MARK: - UICollectionViewDataSource
extension GenresCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            fatalError("Failed to dequeue GenreCollectionViewCell")
        }
        cell.configure(with: genres[indexPath.row])

        // Update the cell's appearance based on whether it's selected
        let isSelected = indexPath == selectedIndex
        cell.setSelected(isSelected)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GenresCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Skip the delegate notifying and network request during initial selection
        guard let previousIndex = selectedIndex else {
            selectedIndex = indexPath
            updateSelectionRendering(collectionView, indexPath: indexPath, isSelected: true)
            return
        }

        // Deselect the previous item
        collectionView.deselectItem(at: previousIndex, animated: false)
        updateSelectionRendering(collectionView, indexPath: previousIndex, isSelected: false)
        // Select the new item
        selectedIndex = indexPath
        updateSelectionRendering(collectionView, indexPath: indexPath, isSelected: true)
        // Notify the delegate
        let genre = genres[indexPath.row]
        delegate?.didSelectGenre(genre)
    }

    private func updateSelectionRendering(_ collectionView: UICollectionView, indexPath: IndexPath, isSelected: Bool) {
        let cell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell
        cell?.setSelected(isSelected)
    }
}
