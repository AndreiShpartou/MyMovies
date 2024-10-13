//
//  EditProfileViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/10/2024.
//

import UIKit

protocol EditProfileViewControllerProtocol {
    var presenter: EditProfilePresenterProtocol { get set }
}

class EditProfileViewController: UIViewController, EditProfileViewControllerProtocol {
    var presenter: EditProfilePresenterProtocol

    private let editProfileView: EditProfileViewProtocol

    // MARK: - Init
    init(editProfileView: EditProfileViewProtocol, presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        self.editProfileView = editProfileView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
