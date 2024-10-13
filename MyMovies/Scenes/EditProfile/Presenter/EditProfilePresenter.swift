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

    // MARK: - Init
    init(
        view: EditProfileViewProtocol? = nil,
        interactor: EditProfileInteractorProtocol,
        router: EditProfileRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Section Heading
extension EditProfilePresenter: EditProfileInteractorOutputProtocol {
}
