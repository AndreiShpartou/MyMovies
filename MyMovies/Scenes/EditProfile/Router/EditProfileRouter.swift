//
//  EditProfileRouter.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import UIKit

final class EditProfileRouter: EditProfileRouterProtocol {
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    func navigateToRoot() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
