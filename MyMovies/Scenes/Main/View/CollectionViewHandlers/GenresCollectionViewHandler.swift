//
//  GenresCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

protocol GenresCollectionViewDelegate: AnyObject {
    func didSelectGenre(_ genre: GenreViewModelProtocol)
}

final class GenresCollectionViewHandler: NSObject {
    weak var delegate: GenresCollectionViewDelegate?

    private var genres: [GenreViewModelProtocol] = []
    private var selectedIndex: IndexPath?

    // MARK: - Public
    func configure(with genres: [GenreViewModelProtocol]) {
        self.genres = genres
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
            selectItem(at: indexPath, in: collectionView)

            return
        }
        // Deselect the previous item
        deselectItem(at: previousIndex, in: collectionView)
        // Select the new item
        selectItem(at: indexPath, in: collectionView)
        // Notify the delegate
        delegate?.didSelectGenre(genres[indexPath.row])
    }

    private func deselectItem(at indexPath: IndexPath, in collectionView: UICollectionView) {
        collectionView.deselectItem(at: indexPath, animated: false)
        updateSelectionRendering(collectionView, indexPath: indexPath, isSelected: false)
    }

    private func selectItem(at indexPath: IndexPath, in collectionView: UICollectionView) {
        selectedIndex = indexPath
        updateSelectionRendering(collectionView, indexPath: indexPath, isSelected: true)
    }

    private func updateSelectionRendering(_ collectionView: UICollectionView, indexPath: IndexPath, isSelected: Bool) {
        let cell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell
        cell?.setSelected(isSelected)
    }
}
