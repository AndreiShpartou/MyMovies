//
//  EditProfileInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

protocol EditProfileInteractorProtocol {
    var presenter: EditProfileInteractorOutputProtocol? { get set }

    func fetchUserProfile()
}

protocol EditProfileInteractorOutputProtocol: AnyObject {
    func didFetchUserProfile(_ profile: UserProfileProtocol)
    func didFailToFetchData(with error: Error)
}
