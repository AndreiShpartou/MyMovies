//
//  UserProfileViewModelProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import UIKit

protocol UserProfileViewModelProtocol {
    var id: Int { get}
    var name: String { get }
    var email: String { get }
    var profileImageURL: URL? { get }
}

protocol ProfileSettingsSectionViewModelProtocol {
    var title: String { get }
    var items: [ProfileSettingsItemViewModelProtocol] { get }
}

protocol ProfileSettingsItemViewModelProtocol {
    var icon: UIImage? { get }
    var title: String { get }
}
