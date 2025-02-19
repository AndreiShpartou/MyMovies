//
//  PersonCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/09/2024.
//

import Foundation
import UIKit

protocol PersonCollectionViewHandlerDelegate: AnyObject {
    func didSelectPerson(personID: Int)
}

final class PersonCollectionViewHandler: NSObject {
    weak var delegate: PersonCollectionViewHandlerDelegate?

    private var persons: [PersonViewModelProtocol] = []

    // MARK: - Public
    func configure(with persons: [PersonViewModelProtocol]) {
        self.persons = persons
        self.persons.sort { $0.popularity > $1.popularity }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectPerson(personID: persons[indexPath.row].id)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonCollectionViewHandler: UICollectionViewDelegateFlowLayout {
}
