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

    // MARK: - Public
    func configure(with labelText: String?, and textViewText: String?) {
        textInfoView.configure(with: labelText, and: textViewText)
    }
}
