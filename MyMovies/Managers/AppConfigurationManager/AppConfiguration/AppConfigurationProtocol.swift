//
//  AppConfigurationProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

protocol AppConfigurationProtocol {
    var apiConfig: APIConfigurationProtocol { get }
    var language: String { get }
}
