//
//  GenresCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

final class GenresCollectionViewHandler: NSObject {
    weak var delegate: MainViewDelegate?

    private var genres: [Genre] = []

    // MARK: - Public
    func configure(with genres: [Genre]) {
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
        // Temporary
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = .primarySoft
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GenresCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.row]
        delegate?.didSelectGenre(genre)
    }
}
