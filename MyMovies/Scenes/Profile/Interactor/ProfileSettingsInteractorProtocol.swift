//
//  ProfileSettingsInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol ProfileSettingsInteractorProtocol: AnyObject {
    func fetchUserProfile()
    func fetchSettingsItems()
}

protocol ProfileSettingsInteracrotOutputProtocol: AnyObject {
//    func didFetchUserProfile(_ profile: UserProfile)
//    func didFetchSettingsItems(_ sections: [ProfileSettingsSection])
    func didFailToFetchData(with error: Error)
}
