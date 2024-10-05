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

    // MARK: - Public
    func configure(with labelText: String?, and textViewText: String?, title: String) {
        textInfoView.configure(with: labelText, and: textViewText, title: title)
    }
}

// MARK: - TextInfoGeneralViewDelegate
extension TextInfoGeneralViewController: TextInfoGeneralViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
}
