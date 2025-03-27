//
//  ProfileRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 02/08/2024.
//

import UIKit

protocol ProfileRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func navigateToEditProfile()
    func navigateToSignIn()
    func navigateToGeneralTextInfoScene(labelText: String?, textViewText: String?, title: String?)
}
