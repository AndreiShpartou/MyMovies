//
//  PersonCircleCollectionViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 16/11/2024.
//

import UIKit

protocol PersonsCollectionViewDelegate: AnyObject {
    func didSelectPerson(personID: Int)
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
        return max(persons.count, 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if persons.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceHolderCollectionViewCell.identifier, for: indexPath) as? PlaceHolderCollectionViewCell else {
                fatalError("Failed to dequeue PlaceHolderCollectionViewCell")
            }
            cell.configure(with: Asset.TabBarIcons.search.image, and: "There Are No Persons Yet!")

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCircleCollectionViewCell.identifier, for: indexPath) as? PersonCircleCollectionViewCell else {
                fatalError("Failed to dequeue PersonCircleCollectionViewCell")
            }
            cell.configure(with: persons[indexPath.row])

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PersonsCircleCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPerson = persons[indexPath.row]
        delegate?.didSelectPerson(personID: selectedPerson.id)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonsCircleCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateItemSize(for: collectionView)
    }

    private func calculateItemSize(for collectionView: UICollectionView) -> CGSize {
        if persons.isEmpty {
            // Full size when no persons are available
            return CGSize(width: collectionView.bounds.width - 8, height: collectionView.bounds.height - 8)
        } else {
            // Fixed size when persons are available
            return CGSize(width: 90, height: 110)
        }
    }
}
