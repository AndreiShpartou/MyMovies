//
//  ProfileSettingsPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation
import FirebaseAuth

final class ProfileSettingsPresenter: ProfileSettingsPresenterProtocol {
    weak var view: ProfileSettingsViewProtocol?
    var interactor: ProfileSettingsInteractorProtocol
    var router: ProfileRouterProtocol

    private let mapper: DomainModelMapperProtocol

    // MARK: - Init
    init(
        view: ProfileSettingsViewProtocol?,
        interactor: ProfileSettingsInteractorProtocol,
        router: ProfileRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - ProfileSettingsPresenterProtocol
    func viewDidLoad() {
        interactor.fetchSettingsItems()

        // User profile will be fetched automatically
        // By setting up the auth observer and Firebase listener in the interactor
        // The listener is triggered for the first time during setup, even without an actual event happening.
        // interactor.fetchUserProfile()
    }

    func navigateToEditProfile() {
        router.navigateToEditProfile()
    }

    func navigateToSignIn() {
        router.navigateToSignIn()
    }

    func didSelectSetting(at indexPath: IndexPath) {
        handleSettingsItemSelection(at: indexPath)
    }

    func signOut() {
        view?.setLoadingIndicator(isVisible: true)
        interactor.signOut()
    }
}

// MARK: - ProfileSettingsInteractorOutputProtocol
extension ProfileSettingsPresenter: ProfileSettingsInteractorOutputProtocol {
    func didFetchUserProfile(_ profile: UserProfile) {
        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to load profile", underlying: nil))

            return
        }
        view?.showUserProfile(profileViewModel)
        view?.setLoadingIndicator(isVisible: false)
        router.navigateToRoot()
    }

    func didBeginProfileUpdate() {
        view?.setLoadingIndicator(isVisible: true)
    }

    func didFetchSettingsItems(_ sections: [ProfileSettingsSection]) {
        guard let sectionsViewModel = mapper.map(data: sections, to: [ProfileSettingsSectionViewModel].self) else {
            didFailToFetchData(with: AppError.mappingError(message: "Failed to map settings", underlying: nil))

            return
        }

        view?.showSettingsItems(sectionsViewModel)
    }

    func didFetchDataForGenerelTextScene(labelText: String?, textViewText: String?, title: String?) {
        router.navigateToGeneralTextInfoScene(labelText: labelText, textViewText: textViewText, title: title)
    }

    func didLogOut() {
        view?.showSignOutItems()
        view?.setLoadingIndicator(isVisible: false)
    }

    func didFailToFetchData(with error: Error) {
        let appError = ErrorManager.toAppError(error)
        view?.showError(with: ErrorManager.toUserMessage(from: appError))

        view?.setLoadingIndicator(isVisible: false)
    }
}

// MARK: - Private
extension ProfileSettingsPresenter {
    private func handleSettingsItemSelection(at indexPath: IndexPath) {
        let item = interactor.getSettingsSectionItem(at: indexPath)
        switch item {
        case .legalAndPolicies, .aboutUs:
            guard let plistkey = item.plistkey else {
                return
            }

            interactor.fetchDataForGeneralTextScene(for: plistkey)
        default:
            break
        }
    }
}
