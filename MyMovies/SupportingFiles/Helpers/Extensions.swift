//
//  Extensions.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/07/2024.
//

import UIKit

// MARK: - UIView
extension UIView {
    static func createCommonView(clipsToBounds: Bool = false, cornderRadius: CGFloat = 0) -> UIView {
        let view = UIView()
        view.clipsToBounds = clipsToBounds
        view.layer.cornerRadius = cornderRadius

        return view
    }

    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - UILabel
extension UILabel {
    static func createLabel(
        fontSize: CGFloat,
        weight: UIFont.Weight,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .left,
        textColor: UIColor? = nil,
        text: String? = nil
    ) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.text = text
        if let textColor = textColor {
            label.textColor = textColor
        }

        return label
    }
}

// MARK: - UIImageView
extension UIImageView {
    static func createImageView(contentMode: UIView.ContentMode, clipsToBounds: Bool = false, cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.clipsToBounds = clipsToBounds
        imageView.layer.cornerRadius = cornerRadius

        return imageView
    }
}

// MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView {
    static func createSpinner(style: Style) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true

        return spinner
    }
}

// MARK: - UIButton
extension UIButton {
    static func createFavouriteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red

        return button
    }
}

// MARK: - HeadingUISearchBar
extension UISearchBar {
    static func createSearchBar(style: UISearchBar.Style = .minimal, placeholder: String) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = style

        return searchBar
    }
}

// MARK: - UIColor
extension UIColor {
    // Convenience initializer to create UIColor from a hex string
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt64 = 0

        // Convert the hex string into an integer
        Scanner(string: hex).scanHexInt64(&rgb)

        // Extract the red, green, and blue components from the RGB value
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // MARK: - StaticColors
    // Primary
    static let primaryBackground: UIColor = .init(hex: "1F1D2B")
    static let primarySoft: UIColor = .init(hex: "252836")
    static let primaryBlueAccent: UIColor = .init(hex: "12CDD9")
    // Secondary
    static let secondaryGreen: UIColor = .init(hex: "22B07D")
    static let secondaryOrange: UIColor = .init(hex: "FF8700")
    static let secondaryRed: UIColor = .init(hex: "FF7256")
    // TextColors
    static let textColorBlack: UIColor = .init(hex: "171725")
    static let textColorDarkGrey: UIColor = .init(hex: "696974")
    static let textColorGrey: UIColor = .init(hex: "92929D")
    static let textColorWhiteGrey: UIColor = .init(hex: "F1F1F5")
    static let textColorWhite: UIColor = .init(hex: "FFFFFF")
    static let textColorLineDark: UIColor = .init(hex: "EAEAEA")
    
}
