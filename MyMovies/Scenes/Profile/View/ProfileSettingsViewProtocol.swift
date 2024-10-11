//
//  ProfileSettingsViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol ProfileSettingsViewProtocol: UIView {
    var delegate: ProfileSettingsInteractionDelegate? { get set }
    var presenter: ProfileSettingsPresenterProtocol? { get set }

    func showUserProfile(_ profile: UserProfileViewModelProtocol)
    func showSettingsItems(_ items: [ProfileSettingsSectionViewModelProtocol])
    func showError(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

protocol ProfileSettingsInteractionDelegate: AnyObject {
    func didTapEditProfile()
    func didSelectSetting(at indexPath: IndexPath)
}
