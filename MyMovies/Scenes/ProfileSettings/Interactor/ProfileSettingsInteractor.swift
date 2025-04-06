//
//  ProfileSettingsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation
import FirebaseAuth

final class ProfileSettingsInteractor: ProfileSettingsInteractorProtocol {
    weak var presenter: ProfileSettingsInteractorOutputProtocol? {
        didSet {
            userProfileObserver.delegate = presenter
            userProfileObserver.startObserving()
        }
    }

    private let networkManager: NetworkServiceProtocol
    private let userProfileObserver: UserProfileObserverProtocol

    private var settingsSections: [ProfileSettingsSection] = []
    private var plistLoader: PlistConfigurationLoaderProtocol?

    // MARK: - Init
    init(
        networkManager: NetworkServiceProtocol = NetworkService.shared,
        plistLoader: PlistConfigurationLoaderProtocol? = PlistConfigurationLoader(),
        userProfileObserver: UserProfileObserverProtocol = UserProfileObserver()
    ) {
        self.networkManager = networkManager
        self.plistLoader = plistLoader
        self.userProfileObserver = userProfileObserver
    }

    // MARK: - ProfileSettingsInteractorProtocol
    func fetchUserProfile() {
        userProfileObserver.fetchUserProfile()
    }

    func fetchSettingsItems() {
        networkManager.fetchSettingsSections { [weak self] result in
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
        let details = plistLoader?.loadGeneralTextSceneData(for: key)
        presenter?.didFetchDataForGenerelTextScene(labelText: details?.labelText, textViewText: details?.textViewText, title: details?.title)
    }

    func getSettingsSectionItem(at indexPath: IndexPath) -> ProfileSettingsItem {
        return settingsSections[indexPath.section].items[indexPath.row]
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            presenter?.didFailToFetchData(with: signOutError)
        }
    }

    // MARK: - Deinit
    deinit {
        userProfileObserver.stopObserving()
    }
}
