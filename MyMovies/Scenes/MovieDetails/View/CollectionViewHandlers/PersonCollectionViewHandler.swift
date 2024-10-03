//
//  PersonCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/09/2024.
//

import Foundation
import UIKit

final class PersonCollectionViewHandler: NSObject {
    private var persons: [PersonViewModelProtocol] = []

    // MARK: - Public
    func configure(with persons: [PersonViewModelProtocol]) {
        self.persons = persons
    }
}

// MARK: - UICollectionViewDataSource
extension PersonCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier, for: indexPath) as? PersonCollectionViewCell  else {
            fatalError("Failed to dequeue PersonCollectionViewCell")
        }
        cell.configure(with: persons[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PersonCollectionViewHandler: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonCollectionViewHandler: UICollectionViewDelegateFlowLayout {
}
