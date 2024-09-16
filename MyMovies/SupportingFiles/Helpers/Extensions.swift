//
//  Extensions.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 29/07/2024.
//

import UIKit
import SnapKit

// MARK: - UIView
extension UIView {
    static func createCommonView(
        clipsToBounds: Bool = false,
        cornderRadius: CGFloat = 0,
        backgroundColor: UIColor? = nil,
        frame: CGRect = .zero
    ) -> UIView {
        let view = UIView(frame: frame)
        view.clipsToBounds = clipsToBounds
        view.backgroundColor = backgroundColor
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

// MARK: - UICollectionView
extension UICollectionView {
    static func createCommonCollectionView(
        itemSize: CGSize,
        cellType: UICollectionViewCell.Type,
        reuseIdentifier: String,
        scrollDirection: UICollectionView.ScrollDirection = .horizontal,
        minimumLineSpacing: CGFloat = 8
    ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)

        return collectionView
    }
}

// MARK: - UIStackView
extension UIStackView {
    static func createCommonStackView(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = .clear

        return stackView
    }
}

// MARK: - UILabel
extension UILabel {
    static func createLabel(
        font: UIFont,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .left,
        textColor: UIColor? = nil,
        text: String? = nil
    ) -> UILabel {
        let label = UILabel()
        label.font = font
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
    static func createImageView(
        contentMode: UIView.ContentMode,
        clipsToBounds: Bool = false,
        cornerRadius: CGFloat = 0,
        image: UIImage? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.clipsToBounds = clipsToBounds
        imageView.layer.cornerRadius = cornerRadius
        imageView.image = image

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
        button.backgroundColor = .primarySoft
        button.layer.cornerRadius = 10
        button.tintColor = .secondaryRed

        return button
    }
}

// MARK: - UISearchBar
extension UISearchBar {
    static func createSearchBar(
        style: UISearchBar.Style = .minimal,
        placeholder: String
    ) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = style

        guard let textField = searchBar.value(forKey: "searchField") as? UITextField else {
            return searchBar
        }

        textField.backgroundColor = .primarySoft
        textField.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(searchBar)
        }

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textColorGrey,
            .font: Typography.Medium.subhead
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)

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
    static var primaryBackground: UIColor {
        return .init(hex: "1F1D2B")
    }
    static var primarySoft: UIColor {
        return .init(hex: "252836")
    }
    static var primaryBlueAccent: UIColor {
        return .init(hex: "12CDD9")
    }
    static var primaryBlack: UIColor {
        return .init(hex: "121212")
    }
    // Secondary
    static var secondaryGreen: UIColor {
        return .init(hex: "22B07D")
    }
    static var secondaryOrange: UIColor {
        return .init(hex: "FF8700")
    }
    static var secondaryRed: UIColor {
        return .init(hex: "FF7256")
    }
    // TextColors
    static var textColorBlack: UIColor {
        return .init(hex: "171725")
    }
    static var textColorDarkGrey: UIColor {
        return .init(hex: "696974")
    }
    static var textColorGrey: UIColor {
        return .init(hex: "92929D")
    }
    static var textColorWhiteGrey: UIColor {
        return .init(hex: "F1F1F5")
    }
    static var textColorWhite: UIColor {
        return .init(hex: "FFFFFF")
    }
    static var textColorLineDark: UIColor {
        return .init(hex: "EAEAEA")
    }
}

// MARK: - UIFont
extension UIFont {
    static func montserratRegular(size: CGFloat) -> UIFont {
        return .init(name: FontName.regular, size: size) ?? .systemFont(ofSize: size)
    }

    static func montserratMedium(size: CGFloat) -> UIFont {
        return .init(name: FontName.medium, size: size) ?? .systemFont(ofSize: size)
    }

    static func montserratSemiBold(size: CGFloat) -> UIFont {
        return .init(name: FontName.semiBold, size: size) ?? .systemFont(ofSize: size)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
