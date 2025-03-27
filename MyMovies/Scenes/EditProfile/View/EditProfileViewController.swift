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

    // MARK: - LifeCycle
    override func loadView() {
        view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup notification observers
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove notification observers
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - Setup
extension EditProfileViewController {
    private func setupViewController() {
        title = "Edit Profile"
        setupNavigationController()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
        navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
    }
}

// MARK: - ActionMethods
extension EditProfileViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // Calculating y position where keyboard overlap view
        guard let textField = view.selectedTextField else {
            return
        }
        // Convert from Subviews coordinates to View coordinates
        let textFieldOrigin = view.convert(textField.frame.origin, from: textField.superview)
        let positionYForChecking = textFieldOrigin.y + textField.frame.height + Sizes.Small.padding
        // Convert from UIWindows coordinates to View coordinates
        let keyboardOrigin = view.convert(keyboardSize.origin, from: view.window)

        editProfileView.adjustScrollInset(with: keyboardSize.height)

        if positionYForChecking > keyboardOrigin.y {
            editProfileView.adjustScrollOffset(with: keyboardSize.height)
        }
    }

    @objc
    private func keyboardWillHide(notification: Notification) {
        editProfileView.adjustScrollInset(with: 0)
    }
}
