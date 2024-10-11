//
//  ProfileRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import Foundation

protocol ProfileRouterProtocol: AnyObject {
    func navigateToEditProfile()
    func navigateToGeneralTextInfoScene(labelText: String?, textViewText: String?, title: String?)
}
