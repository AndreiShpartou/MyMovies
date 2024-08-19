//
//  AppConfiguration.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

// MARK: - AppConfiguration
struct AppConfiguration: AppConfigurationProtocol {
    var apiConfig: APIConfigurationProtocol
    let language: String
}
