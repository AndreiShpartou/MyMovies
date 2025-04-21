//
//  PlistConfigurationLoaderProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

protocol PlistConfigurationLoaderProtocol {
    func loadConfiguration(for country: Country) -> APIConfigurationProtocol?
    func loadGeneralTextSceneData(for key: String) -> GeneralDetails
    func loadCloudinaryConfig() -> CloudinaryAuth?
}
