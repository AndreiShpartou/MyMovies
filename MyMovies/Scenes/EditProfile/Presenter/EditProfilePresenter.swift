//
//  EditProfilePresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

final class EditProfilePresenter: EditProfilePresenterProtocol {
    weak var view: EditProfileViewProtocol?
    var interactor: EditProfileInteractorProtocol
    var router: EditProfileRouterProtocol

    private let mapper: DomainModelMapperProtocol

    // MARK: - Init
    init(
        view: EditProfileViewProtocol? = nil,
        interactor: EditProfileInteractorProtocol,
        router: EditProfileRouterProtocol,
        mapper: DomainModelMapperProtocol = DomainModelMapper()
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mapper = mapper
    }

    // MARK: - Public
    func viewDidLoad() {
        view?.showLoadingIndicator()

        interactor.fetchUserProfile()
    }

    func didTapSaveChanges(name: String, profileImage: Data?) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoadingIndicator()
        }

        interactor.updateUserProfile(name: name, profileImage: profileImage)
    }
}

// MARK: - Section Heading
extension EditProfilePresenter: EditProfileInteractorOutputProtocol {
    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
            view?.showError(NSLocalizedString("Failed to load profile", comment: "Error message for failed profile load"))
            view?.hideLoadingIndicator()

            return
        }
        view?.showUserProfile(profileViewModel)
        view?.hideLoadingIndicator()
    }

    func didFailToFetchData(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showError(error.localizedDescription)
    }

    func didCloseWithNoChanges() {
        router.navigateToRoot()
    }
}
