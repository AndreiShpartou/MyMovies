//
//  ProfileSettingsPresenterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol ProfileSettingsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func navigateToEditProfile()
    func navigateToSignIn()
    func didSelectSetting(at indexPath: IndexPath)
    func signOut()
}
