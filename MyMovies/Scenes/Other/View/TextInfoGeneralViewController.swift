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
        textInfoView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: - Public
    func configure(with labelText: String?, and textViewText: String?, title: String?) {
        textInfoView.configure(with: labelText, and: textViewText, title: title)
    }
}

// MARK: - Setup
extension TextInfoGeneralViewController {
    private func setupView() {
        setupNavigationController()
    }

    private func setupNavigationController() {
        if let isNavigationBarHidden = navigationController?.isNavigationBarHidden,
            !isNavigationBarHidden {
            textInfoView.hideDefaultTitle()
            navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleAttributes()
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
