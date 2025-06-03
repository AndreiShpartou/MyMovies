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
    func signOut()
}

protocol ProfileSettingsInteractorOutputProtocol: AnyObject, UserProfileObserverDelegate {
    func didFetchSettingsItems(_ sections: [ProfileSettingsSection])
    func didFetchDataForGenerelTextScene(labelText: String?, textViewText: String?, title: String?)
}
