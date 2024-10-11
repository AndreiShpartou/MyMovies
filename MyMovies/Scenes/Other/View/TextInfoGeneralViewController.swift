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
            setupCustomBackNavigationButton()
        }
    }

    private func setupCustomBackNavigationButton() {
        // Set custom view for the back button
        let backgroundView: UIView = .createCommonView(cornerRadius: 18, backgroundColor: .primarySoft)
        let buttonImage = UIImage(systemName: "chevron.left")?.withTintColor(.textColorWhite, renderingMode: .alwaysOriginal)
        let backButton = UIButton(type: .system)
        backButton.setImage(buttonImage, for: .normal)
        backButton.tintColor = .primaryBackground
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        // Constraints
        backgroundView.addSubviews(backButton)
        backgroundView.snp.makeConstraints { $0.width.height.equalTo(36) }
        backButton.snp.makeConstraints { $0.center.equalToSuperview() }
        // Set UIBarButtonItem
        let customBackBarButtonItem = UIBarButtonItem(customView: backgroundView)
        navigationItem.leftBarButtonItem = customBackBarButtonItem
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
