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
        view?.setLoadingIndicator(isVisible: true)

        interactor.fetchUserProfile()
    }

    func didTapSaveChanges(name: String, profileImage: Data?) {
        view?.setLoadingIndicator(isVisible: true)

        interactor.updateUserProfile(name: name, profileImage: profileImage)
    }
}

// MARK: - Section Heading
extension EditProfilePresenter: EditProfileInteractorOutputProtocol {
    func didFetchUserProfile(_ profile: UserProfileProtocol) {
        guard let profileViewModel = mapper.map(data: profile, to: UserProfileViewModel.self) else {
            didFailToFetchData(with: AppError.customError(message: "Failed to load profile", comment: ""))

            return
        }

        view?.showUserProfile(profileViewModel)
        view?.setLoadingIndicator(isVisible: false)
    }

    func didFailToFetchData(with error: Error) {
        view?.showError(error.localizedDescription)
        view?.setLoadingIndicator(isVisible: false)
    }

    func didFinishProfileUpdate() {
        view?.setLoadingIndicator(isVisible: false)
    }

    func didCloseWithNoChanges() {
        view?.setLoadingIndicator(isVisible: false)
        router.navigateToRoot()
    }
}
