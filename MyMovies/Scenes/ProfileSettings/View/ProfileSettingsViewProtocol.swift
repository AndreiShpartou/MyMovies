//
//  ProfileSettingsViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol ProfileSettingsViewProtocol: UIView {
    var delegate: ProfileSettingsInteractionDelegate? { get set }

    func showUserProfile(_ profile: UserProfileViewModelProtocol)
    func showSettingsItems(_ items: [ProfileSettingsSectionViewModelProtocol])
    func showSignOutItems()
    func setLoadingIndicator(isVisible: Bool)
    func setNilValueForScrollOffset()
    func showError(with message: String)
}

protocol ProfileSettingsInteractionDelegate: AnyObject {
    func didTapEditProfile()
    func didTapSignIn()
    func didTapSignOut()
    func didSelectSetting(at indexPath: IndexPath)
}
