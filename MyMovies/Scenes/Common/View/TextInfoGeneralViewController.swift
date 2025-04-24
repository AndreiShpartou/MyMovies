//
//  TextInfoGeneralViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/10/2024.
//

import UIKit

final class TextInfoGeneralViewController: UIViewController {
    private let textInfoView: TextInfoGeneralViewProtocol = TextInfoGeneralView()

    // MARK: - LifeCycle
    override func loadView() {
        view = textInfoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationController()
    }

    // MARK: - Public
    func configure(with labelText: String?, and textViewText: String?, title: String?) {
        textInfoView.configure(with: labelText, and: textViewText, title: title)
    }
}

// MARK: - Setup
extension TextInfoGeneralViewController {
    private func setupViewController() {
        textInfoView.delegate = self
    }

    private func setupNavigationController() {
        if isBeingPresented {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
            textInfoView.hideDefaultTitle()
            // Setting the custom title font
            navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
            // Custom left button
            navigationItem.leftBarButtonItem = .createCustomBackBarButtonItem(action: #selector(backButtonTapped), target: self)
        }
    }
}

// MARK: - ActionMethods
extension TextInfoGeneralViewController {
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextInfoGeneralViewDelegate
extension TextInfoGeneralViewController: TextInfoGeneralViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
}
