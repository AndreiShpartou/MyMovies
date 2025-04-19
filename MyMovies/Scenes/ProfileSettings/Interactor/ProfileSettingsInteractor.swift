//
//  ProfileSettingsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

final class ProfileSettingsInteractor: ProfileSettingsInteractorProtocol {
    weak var presenter: ProfileSettingsInteractorOutputProtocol? {
        didSet {
            userProfileObserver.delegate = presenter
            userProfileObserver.startObserving()
        }
    }

    private let networkService: NetworkServiceProtocol
    private let authService: AuthServiceProtocol
    private let userProfileObserver: UserProfileObserverProtocol

    private var settingsSections: [ProfileSettingsSection] = []
    private var plistLoader: PlistConfigurationLoaderProtocol

    // MARK: - Init
    init(
        networkService: NetworkServiceProtocol,
        authService: AuthServiceProtocol,
        userProfileObserver: UserProfileObserverProtocol,
        plistLoader: PlistConfigurationLoaderProtocol
    ) {
        self.networkService = networkService
        self.authService = authService
        self.userProfileObserver = userProfileObserver
        self.plistLoader = plistLoader
    }

    // MARK: - ProfileSettingsInteractorProtocol
    func fetchUserProfile() {
        userProfileObserver.fetchUserProfile()
    }

    func fetchSettingsItems() {
        networkService.fetchSettingsSections { [weak self] result in
            switch result {
            case .success(let sections):
                DispatchQueue.main.async {
                    self?.presenter?.didFetchSettingsItems(sections)
                    self?.settingsSections = sections
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailToFetchData(with: error)
                }
            }
        }
    }

    func fetchDataForGeneralTextScene(for key: String) {
        let details = plistLoader.loadGeneralTextSceneData(for: key)
        presenter?.didFetchDataForGenerelTextScene(labelText: details.labelText, textViewText: details.textViewText, title: details.title)
    }

    func getSettingsSectionItem(at indexPath: IndexPath) -> ProfileSettingsItem {
        return settingsSections[indexPath.section].items[indexPath.row]
    }

    func signOut() {
        do {
            try authService.signOut()
        } catch let signOutError as NSError {
            presenter?.didFailToFetchData(with: signOutError)
        }
    }

    // MARK: - Deinit
    deinit {
        userProfileObserver.stopObserving()
    }
}
