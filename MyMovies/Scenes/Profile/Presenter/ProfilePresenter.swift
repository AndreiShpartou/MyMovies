//
//  ProfilePresenter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorProtocol
    var router: ProfileRouterProtocol
    
    // MARK: - Init
    init(view: ProfileViewProtocol?, interactor: ProfileInteractorProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
