//
//  ProfileSettingsPresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

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

    func didSelectSettingsItem(_ item: ProfileSettingsItem) {
        router.navigateToSettingItem(item)
    }
}

extension ProfileSettingsPresenter: ProfileSettingsInteracrotOutputProtocol {
    func didFetchUserProfile(_ profile: UserProfile) {
//        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
//            view?.showError("Failed to load profile")
//              view?.showError(NSLocalizedString("Failed to load profile", comment: "Error message for failed profile load"))
//            view?.hideLoadingIndicator()
//            
//            return
//        }
//        view?.showUserProfile(profileViewModel)
    }

    func didFetchSettingsItems(_ sections: [ProfileSettingsSection]) {
        guard let sectionsViewModel = mapper.map(data: sections, to: [ProfileSettingsSectionViewModel].self) else {
            view?.showError(NSLocalizedString("Failed to load settings", comment: "Error message for failed settings load"))
            view?.hideLoadingIndicator()

            return
        }
        view?.showSettingsItems(sectionsViewModel)
    }

    func didFailToFetchData(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showError(error.localizedDescription)
    }
}
