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
    func getSettingsSectionItem(at indexPath: IndexPath) -> ProfileSettingsItem
    func fetchDataForGeneralTextScene(for key: String)
}

protocol ProfileSettingsInteracrotOutputProtocol: AnyObject {
    func didFetchUserProfile(_ profile: UserProfile)
    func didFetchSettingsItems(_ sections: [ProfileSettingsSection])
    func didFailToFetchData(with error: Error)
    func didFetchDataForGenerelTextScene(labelText: String?, textViewText: String?, title: String?)
}
