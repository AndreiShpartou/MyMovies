//
//  ProfilePresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

class ProfilePresenter: ProfileSettingsPresenterProtocol {
    weak var view: ProfileSettingsViewProtocol?
    var interactor: ProfileInteractorProtocol
    var router: ProfileRouterProtocol

    // MARK: - Init
    init(view: ProfileSettingsViewProtocol?, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
