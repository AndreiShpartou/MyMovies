//
//  ProfileInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class ProfileInteractor: ProfileSettingsInteractorProtocol {
    weak var presenter: ProfileSettingsInteracrotOutputProtocol?

    private let networkManager: NetworkManagerProtocol
//    private let userRepository: UserRepositoryProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
//        self.userRepository = userRepository
    }

    // MARK: - ProfileSettingsInteractorProtocol
    func fetchUserProfile() {
//        networkManager.fetchUserProfile { [weak self] result in
//            switch result {
//            case .success(let profile):
//                self?.presenter?.didFetchUserProfile(profile)
//            case .failure(let error):
//                self?.presenter?.didFailToFetchData(with: error)
//            }
//        }
    }

    func fetchSettingsItems() {
        networkManager.fetchSettingsSections { [weak self] result in
            switch result {
            case .success(let sections):
                self?.presenter?.didFetchSettingsItems(sections)
            case .failure(let error):
                self?.presenter?.didFailToFetchData(with: error)
            }
        }
    }
}
