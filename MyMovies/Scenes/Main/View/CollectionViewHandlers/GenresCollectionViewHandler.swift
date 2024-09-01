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
        // Deselect the previous item
        if let previousIndex = selectedIndex {
            collectionView.deselectItem(at: previousIndex, animated: false)
            let previousCell = collectionView.cellForItem(at: previousIndex) as? GenreCollectionViewCell
            previousCell?.setSelected(false)
        }

        // Select the new item
        selectedIndex = indexPath
        let selectedCell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell
        selectedCell?.setSelected(true)

        // Notify the delegate
        let genre = genres[indexPath.row]
        delegate?.didSelectGenre(genre)
    }
}
