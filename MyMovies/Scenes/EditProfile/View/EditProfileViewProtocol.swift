//
//  EditProfileViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import UIKit

protocol EditProfileViewProtocol: UIView, UIViewKeyboardScrollHandlingProtocol {
    var delegate: EditProfileInteractionDelegate? { get set }
    var presenter: EditProfilePresenterProtocol? { get set }

    func showUserProfile(_ profile: UserProfileViewModelProtocol)
    func showError(_ message: String)
    func setLoadingIndicator(isVisible: Bool)
}

protocol EditProfileInteractionDelegate: AnyObject {
    func didTapSaveChanges(name: String, profileImage: UIImage?)
}
