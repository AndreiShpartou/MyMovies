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
    func updateUserProfile(name: String, profileImage: Data?)
}

protocol EditProfileInteractorOutputProtocol: AnyObject {
    func didFetchUserProfile(_ profile: UserProfileProtocol)
    func didFailToFetchData(with error: Error)
    func didFinishProfileUpdate()
    func didCloseWithNoChanges()
}
