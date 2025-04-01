//
//  LoginRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol LoginRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }

    func navigateToSignUp()
    func navigateToMainFlow()
    func dismissScene()
}
