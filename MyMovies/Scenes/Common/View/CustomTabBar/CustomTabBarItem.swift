//
//  CustomTabBarItem.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/08/2024.
//

import UIKit

final class CustomTabBarItem: UIView {
    var isSelected = false {
        didSet {
            updateAppearance()
        }
    }

    private let selectionBackgroundView: UIView = .createCommonView(
        cornerRadius: 12,
        backgroundColor: .primarySoft,
        isHidden: true
    )
    private let itemStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 4,
        distribution: .fill,
        alignment: .center
    )

    private let iconImageView: UIImageView = .createImageView(contentMode: .scaleAspectFit)
    private let titleLabel: UILabel = .createLabel(font: Typography.Medium.subhead, isHidden: true)

    // MARK: - Init
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)

        setupView(icon: icon, title: title)
        updateAppearance()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView(icon: UIImage?, title: String) {
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title

        // Setup subviews
        itemStackView.addArrangedSubview(iconImageView)
        itemStackView.addArrangedSubview(titleLabel)
        addSubviews(selectionBackgroundView, itemStackView)
    }

    private func updateAppearance() {
        if isSelected {
            iconImageView.tintColor = .primaryBlueAccent
            titleLabel.textColor = .primaryBlueAccent
            titleLabel.isHidden = false
            selectionBackgroundView.isHidden = false
        } else {
            iconImageView.tintColor = .textColorGrey
            titleLabel.textColor = .textColorGrey
            titleLabel.isHidden = true
            selectionBackgroundView.isHidden = true
        }
    }
}

// MARK: - Constraints
extension CustomTabBarItem {
    private func setupConstraints() {
        selectionBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        itemStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.greaterThanOrEqualTo(24)
        }

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24) // Standart icon size
        }
    }
}
