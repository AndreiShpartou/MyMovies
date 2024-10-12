//
//  UserProfileViewModel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import UIKit

struct UserProfileViewModel: UserProfileViewModelProtocol {
    let id: Int
    let name: String
    let email: String
    let profileImageURL: URL?
}

struct ProfileSettingsSectionViewModel: ProfileSettingsSectionViewModelProtocol {
    let title: String
    let items: [ProfileSettingsItemViewModelProtocol]
}

struct ProfileSettingsItemViewModel: ProfileSettingsItemViewModelProtocol {
    let icon: UIImage?
    let title: String
}
