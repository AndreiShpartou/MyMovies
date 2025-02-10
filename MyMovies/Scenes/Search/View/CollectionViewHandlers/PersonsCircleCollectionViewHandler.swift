//
//  PersonCircleCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 16/11/2024.
//

import UIKit

protocol PersonsCollectionViewDelegate: AnyObject {
    func didSelectPerson(person: PersonViewModelProtocol)
}

final class PersonsCircleCollectionViewHandler: NSObject {
    weak var delegate: PersonsCollectionViewDelegate?

    private var persons: [PersonViewModelProtocol] = []

    // MARK: - Public
    func configure(with persons: [PersonViewModelProtocol]) {
        self.persons = persons
    }
}

// MARK: - UICollectionViewDataSource
extension PersonsCircleCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCircleCollectionViewCell.identifier, for: indexPath) as? PersonCircleCollectionViewCell else {
            fatalError("Failed to dequeue PersonCircleCollectionViewCell")
        }
        cell.configure(with: persons[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PersonsCircleCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPerson = persons[indexPath.row]
        delegate?.didSelectPerson(person: selectedPerson)
    }
}
