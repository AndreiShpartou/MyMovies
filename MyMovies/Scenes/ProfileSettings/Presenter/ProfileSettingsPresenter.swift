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
        view?.showLoadingIndicator()
        interactor.fetchUserProfile()
        interactor.fetchSettingsItems()
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
        view?.showLoadingIndicator()
        interactor.signOut()
    }
}

// MARK: - ProfileSettingsInteractorOutputProtocol
extension ProfileSettingsPresenter: ProfileSettingsInteractorOutputProtocol {
    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
            view?.showError(AppError.customError(message: "Failed to load profile", comment: "Error message for failed profile load"))
            view?.hideLoadingIndicator()

            return
        }
        view?.showUserProfile(profileViewModel)
        router.navigateToRoot()
    }

    func didFetchSettingsItems(_ sections: [ProfileSettingsSection]) {
        guard let sectionsViewModel = mapper.map(data: sections, to: [ProfileSettingsSectionViewModel].self) else {
            view?.showError(AppError.customError(message: "Failed to load settings", comment: "Error message for failed settings load"))
            view?.hideLoadingIndicator()

            return
        }
        view?.showSettingsItems(sectionsViewModel)
    }

    func didFetchDataForGenerelTextScene(labelText: String?, textViewText: String?, title: String?) {
        router.navigateToGeneralTextInfoScene(labelText: labelText, textViewText: textViewText, title: title)
    }

    func didFailToFetchData(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showError(error)
    }

    func didLogOut() {
        view?.showSignOutItems()
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
