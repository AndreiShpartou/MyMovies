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
        cornerRadius: CGFloat = 0,
        backgroundColor: UIColor? = nil,
        frame: CGRect = .zero,
        borderWidth: CGFloat = 0,
        borderColor: CGColor? = nil,
        masksToBounds: Bool = false,
        isHidden: Bool = false
    ) -> UIView {
        let view = UIView(frame: frame)
        view.clipsToBounds = clipsToBounds
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.layer.masksToBounds = masksToBounds
        view.isHidden = isHidden

        return view
    }

    static func createBorderedViewWithLabel(
        labelText: String? = nil,
        borderWidth: CGFloat = 2,
        borderColor: CGColor = UIColor.primaryBlueAccent.cgColor,
        textColor: UIColor = .primaryBlueAccent
    ) -> UIView {
        let view: UIView = .createCommonView(cornerRadius: 8)
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

    func initHideKeyboard() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(gesture)
    }

    @objc
    private func dismissKeyboard() {
        self.endEditing(true)
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
        borderColor: CGColor? = nil,
        isHidden: Bool = false
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.text = text
        label.isHidden = isHidden

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
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byTruncatingTail

        return textView
    }
}

// MARK: - UITextField
extension UITextField {
    static func createBorderedTextField(
        action: Selector,
        target: Any?,
        placeholder: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        isSecureTextEntry: Bool = false,
        cornerRadius: CGFloat = 30
    ) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .primaryBackground
        textField.font = Typography.Medium.subhead
        textField.textColor = .textColorGrey
        textField.keyboardType = keyboardType
        textField.keyboardAppearance = .dark
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureTextEntry
        // Placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textColorDarkGrey]
        )
        // Add paddings
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        // Adjust border
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderColor = UIColor.unselectedBorder.cgColor
        textField.layer.borderWidth = 1
        // Add target
        textField.addTarget(target, action: action, for: .editingChanged)

        return textField
    }

    func addDoneToolBarButton() {
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()

        self.inputAccessoryView = bar
    }

    @objc
    private func closeKeyboard() {
        self.resignFirstResponder()
    }
}

// MARK: - UIImageView
extension UIImageView {
    static func createImageView(
        contentMode: UIView.ContentMode,
        clipsToBounds: Bool = false,
        cornerRadius: CGFloat = 0,
        image: UIImage? = nil,
        backgroundColor: UIColor? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.clipsToBounds = clipsToBounds
        imageView.layer.cornerRadius = cornerRadius
        imageView.image = image
        imageView.backgroundColor = backgroundColor

        return imageView
    }
}

// MARK: - UIBarButtonItem
extension UIBarButtonItem {
    static func createCustomBackBarButtonItem(action: Selector, target: Any?) -> UIBarButtonItem {
//        // Set custom view for the back button
//        let backgroundView: UIView = .createCommonView(cornerRadius: 18, backgroundColor: .primarySoft)
//        let buttonImage = UIImage(systemName: "chevron.left")?.withTintColor(.textColorWhite, renderingMode: .alwaysOriginal)
//        let backButton = UIButton(type: .system)
//        backButton.setImage(buttonImage, for: .normal)
//        backButton.tintColor = .primaryBackground
//        backButton.addTarget(target, action: action, for: .touchUpInside)
//        // Constraints
//        backgroundView.addSubviews(backButton)
//        backgroundView.snp.makeConstraints { $0.width.height.equalTo(36) }
//        backButton.snp.makeConstraints { $0.center.equalToSuperview() }
        let backButton: UIButton = .createBackNavBarButton(action: action, target: target)

        return UIBarButtonItem(customView: backButton)
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
    convenience init(
        title: String?,
        font: UIFont? = nil,
        titleColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat = 0,
        action: Selector,
        target: Any?
    ) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(.primarySoft, for: .highlighted)
        self.titleLabel?.textAlignment = .center
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius

        self.addTarget(target, action: action, for: .touchUpInside)
    }

    static func createFavouriteButton(isSelected: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal), for: .selected)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.isSelected = isSelected

        return button
    }

    static func createBackNavBarButton(action: Selector, target: Any?) -> UIButton {
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .white
        leftButton.backgroundColor = .primarySoft

        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.layer.cornerRadius = 15

        leftButton.addTarget(target, action: action, for: .touchUpInside)

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
        placeholder: String,
        textFieldCornedRadius: CGFloat = 0,
        textFieldBorderWidth: CGFloat = 0
    ) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = style

        guard let textField = searchBar.value(forKey: "searchField") as? UITextField else {
            return searchBar
        }

        textField.backgroundColor = .primarySoft
        textField.layer.cornerRadius = textFieldCornedRadius
        textField.layer.borderWidth = textFieldBorderWidth
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

// MARK: - Array
extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }

        return self[index]
    }
}

// MARK: - String
extension String {
    // Returns a properly formatted URL string by replacing repeated schemes if present.
    var sanitizedURLString: String {
        if self.hasPrefix("https:https:") {
            return self.replacingOccurrences(of: "https:https:", with: "https:")
        }

        return self
    }

    var sanitizedURL: URL? {
        return URL(string: self.sanitizedURLString)
    }

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
    static var selectedBorder: UIColor {
        UIColor.tintColor
    }
    static var unselectedBorder: UIColor {
        UIColor.primarySoft
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

// MARK: - NotificationCenter
extension Notification.Name {
    static let favouritesAdded = Notification.Name("favouritesAdded")
    static let favouritesRemoved = Notification.Name("favouritesRemoved")
}
