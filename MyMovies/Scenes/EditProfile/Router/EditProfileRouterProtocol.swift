//
//  EditProfileRouterProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import UIKit

protocol EditProfileRouterProtocol {
    var viewController: UIViewController? { get set }

    func navigateToRoot()
}
