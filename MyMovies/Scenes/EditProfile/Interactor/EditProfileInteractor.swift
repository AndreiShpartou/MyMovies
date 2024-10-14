//
//  EditProfileInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

final class EditProfileInteractor: EditProfileInteractorProtocol {
    weak var presenter: EditProfileInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - EditProfileInteractorProtocol
    func fetchUserProfile() {
        networkManager.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.presenter?.didFetchUserProfile(profile)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }
}
