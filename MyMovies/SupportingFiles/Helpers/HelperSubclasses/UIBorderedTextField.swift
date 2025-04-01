//
//  UIBorderedTextField.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

class UIBorderedTextField: UITextField {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(
        placeholder: String?,
        font: UIFont?,
        keyboardType: UIKeyboardType = .default
    ) {
        self.init()

        self.placeholder = placeholder
        self.font = font
        self.keyboardType = keyboardType

        self.autocapitalizationType = .none
        self.returnKeyType = .done
        self.keyboardAppearance = .dark
        self.autocorrectionType = .no

        setupPaddings()
    }
}

// MARK: - Setup
extension UIBorderedTextField {
    private func setupView() {
        contentVerticalAlignment = .center
        // layer
        layer.borderColor = UIColor.unselectedBorder.cgColor
        layer.borderWidth = Sizes.Small.borderWidth
        layer.cornerRadius = Sizes.Medium.cornerRadius
    }
}

// MARK: - Helpers
extension UIBorderedTextField {
    private func setupPaddings() {
        let paddingFrame = CGRect(x: 0, y: 0, width: Sizes.Medium.padding, height: Sizes.XSmall.height)
        let paddingView = UIView(frame: paddingFrame)

        leftView = paddingView
        leftViewMode = .always
        rightView = paddingView
        rightViewMode = .always
    }
}
