//
//  Extensions.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/07/2024.
//

import UIKit

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

extension UIImageView {
    static func createImageView(contentMode: UIView.ContentMode, clipsToBounds: Bool = false, cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.clipsToBounds = clipsToBounds
        imageView.layer.cornerRadius = cornerRadius

        return imageView
    }
}

extension UIActivityIndicatorView {
    static func createSpinner(style: Style) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true

        return spinner
    }
}

extension UIButton {
    static func createFavouriteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red

        return button
    }
}

extension UISearchBar {
    static func createSearchBar(style: UISearchBar.Style = .minimal, placeholder: String) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = style

        return searchBar
    }
}
