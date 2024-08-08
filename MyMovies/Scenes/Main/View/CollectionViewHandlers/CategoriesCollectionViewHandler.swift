//
//  CategoriesCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/08/2024.
//
import UIKit

final class CategoriesCollectionViewHandler: NSObject {
    weak var delegate: MainViewDelegate?

    private var categories: [Category] = []

    // MARK: - Public
    func configure(with categories: [Category]) {
        self.categories = categories
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("Failed to dequeue CategoryCollectionViewCell")
        }
        cell.configure(with: categories[indexPath.row].rawValue)
        // Temporary
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = .primarySoft
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        delegate?.didSelectCategory(category)
    }
}
