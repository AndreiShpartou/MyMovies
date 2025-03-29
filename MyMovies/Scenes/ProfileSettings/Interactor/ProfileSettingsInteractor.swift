//
//  ProfileSettingsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ProfileSettingsInteractor: ProfileSettingsInteractorProtocol {
    weak var presenter: ProfileSettingsInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let firestoreDB = Firestore.firestore()

    private var settingsSections: [ProfileSettingsSection] = []
    private var plistLoader: PlistConfigurationLoaderProtocol?
    private var authObserver: NSObjectProtocol?
    private var firestoreObserver: ListenerRegistration?

    // MARK: - Init
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        plistLoader: PlistConfigurationLoaderProtocol? = PlistConfigurationLoader()
    ) {
        self.networkManager = networkManager
        self.plistLoader = plistLoader

        setupAuthObserver()
    }

    // MARK: - ProfileSettingsInteractorProtocol
    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            return
        }

        // Fetch full data and update UI if user is signed in
        fetchAdditionalUserData(uid: user.uid, email: email)

        // Add a listener to fetch user data if still not added
        setupFireStoreListener(uid: user.uid, email: email)
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
        if let authObserver = authObserver {
            Auth.auth().removeStateDidChangeListener(authObserver)
        }

        firestoreObserver?.remove()
        firestoreObserver = nil
    }
}

// MARK: - Private Helpers
extension ProfileSettingsInteractor {
    // Fetch additional data from the Firestore
    private func fetchAdditionalUserData(uid: String, email: String) {
        firestoreDB.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }

                return
            }

            guard let userData = snapshot?.data() else {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: AppError.customError(message: "Failed to fetch user data", comment: "Error message for failed user data fetch"))
                }

                return
            }

            // Return if data wasn't stored -> Wait until it'll be stored and fetching be triggered by the listener
            guard let name = userData["name"] as? String else {
                return
            }

            let userProfile = UserProfile(
                id: uid,
                name: name,
                email: email,
                profileImageURL: userData["profileImageURL"] as? URL
            )

            DispatchQueue.main.async {
                self.presenter?.didFetchUserProfile(userProfile)
            }
        }
    }
}

// MARK: - Observers
extension ProfileSettingsInteractor {
    private func setupAuthObserver() {
        authObserver = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            guard let user = user,
            let email = user.email else {
                // User is signed out or does not exist
                self.firestoreObserver?.remove()
                firestoreObserver = nil

                DispatchQueue.main.async {
                    self.presenter?.didLogOut()
                }

                return
            }

            // Add a listener to fetch additional user data via Firestore
            self.setupFireStoreListener(uid: user.uid, email: email)
        }
    }

    private func setupFireStoreListener(uid: String, email: String) {
        guard firestoreObserver == nil else { return }

        firestoreObserver = firestoreDB.collection("users").document(uid).addSnapshotListener { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchData(with: error)
                }
            }

            fetchAdditionalUserData(uid: uid, email: email)
        }
    }
}
