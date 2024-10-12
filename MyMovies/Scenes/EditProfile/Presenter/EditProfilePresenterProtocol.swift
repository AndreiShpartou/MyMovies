//
//  EditProfilePresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

protocol EditProfilePresenterProtocol {
    var view: EditProfileViewProtocol? { get set }
    var interactor: EditProfileInteractorProtocol { get set }
    var router: EditProfileRouterProtocol { get set }
}
