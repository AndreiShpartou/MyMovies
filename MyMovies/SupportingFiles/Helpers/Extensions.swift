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
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            parentResponder = responder.next
        }
        return nil
    }

    static func createCommonView(
        clipsToBounds: Bool = false,
        cornderRadius: CGFloat = 0,
        backgroundColor: UIColor? = nil,
        frame: CGRect = .zero,
        borderWidth: CGFloat = 0,
        borderColor: CGColor? = nil,
        masksToBounds: Bool = false
    ) -> UIView {
        let view = UIView(frame: frame)
        view.clipsToBounds = clipsToBounds
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornderRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.layer.masksToBounds = masksToBounds

        return view
    }

    static func createBorderedViewWithLabel(
        labelText: String?,
        borderWidth: CGFloat = 2,
        borderColor: CGColor = UIColor.primaryBlueAccent.cgColor,
        textColor: UIColor = .primaryBlueAccent
    ) -> UIView {
        let view: UIView = .createCommonView(cornderRadius: 8)
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.translatesAutoresizingMaskIntoConstraints = false

        let label: UILabel = .createLabel(
            font: Typography.Medium.body,
            textColor: textColor,
            text: labelText
        )

        // Arrangment
        view.addSubviews(label)
        view.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(25)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

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
        cellTypesDict: [String: UICollectionViewCell.Type],
        scrollDirection: UICollectionView.ScrollDirection = .horizontal,
        minimumLineSpacing: CGFloat = 8,
        backgroundColor: UIColor = .clear
    ) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        cellTypesDict.forEach {
            collectionView.register($0.value, forCellWithReuseIdentifier: $0.key)
        }

        return collectionView
    }
}

// MARK: - UIStackView
extension UIStackView {
    static func createCommonStackView(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 8,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
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
        text: String? = nil,
        borderWidth: CGFloat? = nil,
        borderColor: CGColor? = nil
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.text = text
        if let textColor = textColor {
            label.textColor = textColor
        }
        if let borderWidth = borderWidth {
            label.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            label.layer.borderColor = borderColor
        }

        return label
    }
}

// MARK: - UITextVIew
extension UITextView {
    static func createCommonTextView(isScrollEnabled: Bool = false, isUserInteractionEnabled: Bool = true) -> UITextView {
        let textView = UITextView()
        textView.font = Typography.Regular.title
        textView.textColor = .textColorWhiteGrey
        textView.isEditable = false
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        textView.isScrollEnabled = isScrollEnabled
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byTruncatingTail

        return textView
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
        spinner.color = .primaryBlueAccent
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

    static func createBackNavBarButton() -> UIButton {
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .white
        leftButton.backgroundColor = .primarySoft

        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.layer.cornerRadius = 15

        return leftButton
    }

    static func createSeeAllButton(action: Selector, target: Any?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.primaryBlueAccent, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

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

// MARK: - String
extension String {
    func convertHtmlToAttributedString(font: UIFont, textColor: UIColor) -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let attributedString = NSMutableAttributedString()
            let content = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedString.append(content)

            let attributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: textColor
            ]
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))

            return attributedString
        } catch {
            debugPrint("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
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
