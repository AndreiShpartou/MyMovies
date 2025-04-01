//
//  UIPasswordTextField.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

final class UIPasswordTextField: UITextField {
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
        cornerRadius: CGFloat = Sizes.Large.cornerRadius
    ) {
        self.init()

        self.placeholder = placeholder
        self.font = Typography.Medium.subhead
        self.layer.cornerRadius = cornerRadius

        self.backgroundColor = .primaryBackground
        self.isSecureTextEntry = true
        self.textContentType = .oneTimeCode
        self.autocapitalizationType = .none
        self.returnKeyType = .done
        self.keyboardAppearance = .dark
        self.autocorrectionType = .no

        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textColorDarkGrey]
        )

        setupPaddings()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = .primaryBackground
    }
}

// MARK: - Setup
extension UIPasswordTextField {
    private func setupView() {
        contentVerticalAlignment = .center
        // layer
        layer.borderColor = UIColor.unselectedBorder.cgColor
        layer.borderWidth = Sizes.Small.borderWidth
    }
}

// MARK: - ActionMethods
extension UIPasswordTextField {
    @objc
    private func hideShowButtonPressed(_ sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        sender.isSelected = !sender.isSelected
    }
}

// MARK: - Helpers
extension UIPasswordTextField {
    private func setupPaddings() {
        // Setting left view space
        let leftPaddingFrame = CGRect(x: 0, y: 0, width: Sizes.Medium.padding, height: Sizes.Small.height)
        let leftView = UIView(frame: leftPaddingFrame)

        self.leftView = leftView
        leftViewMode = .always

        // Setting right view
        let rightPaddingFrame = CGRect(x: 0, y: 0, width: Sizes.XLarge.padding, height: Sizes.Small.height)
        let rightView = UIView(frame: rightPaddingFrame)
        let showHideButton = getShowHideButton()
        rightView.addSubview(showHideButton)
        showHideButton.center = rightView.center

        self.rightView = rightView
        rightViewMode = .always
    }

    // MARK: - Subview adjustment
    private func getShowHideButton() -> UIButton {
        let button = UIButton()
        let imageHide = UIImage(systemName: "eye.slash.fill")
        let imageShow = UIImage(systemName: "eye.fill")
        button.setImage(imageHide, for: .normal)
        button.setImage(imageShow, for: .selected)
        button.sizeToFit()
        button.addTarget(
            self,
            action: #selector(hideShowButtonPressed),
            for: .touchUpInside
        )

        return button
    }
}
