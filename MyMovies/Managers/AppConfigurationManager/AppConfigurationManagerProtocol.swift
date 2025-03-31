//
//  AppConfigurationManagerProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

protocol AppConfigurationManagerProtocol {
    var appConfig: AppConfigurationProtocol? { get }
    func configure(networkHelper: NetworkHelperProtocol, plistLoader: PlistConfigurationLoaderProtocol)
    func setupCacheConfiguration()
    func setupMainConfiguration()
    func setupFirebaseConfiguration()
}
