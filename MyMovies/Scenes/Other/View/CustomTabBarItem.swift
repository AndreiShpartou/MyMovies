//
//  CustomTabBarItem.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/08/2024.
//

import UIKit

final class CustomTabBarItem: UIView {
    private let iconImageView: UIImageView = .createImageView(contentMode: .scaleAspectFit)
    private let titleLabel: UILabel = .createLabel(font: Typography.Medium.subhead)

    var isSelected = false {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Init
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)

        setupView(icon: icon, title: title)
        updateAppearance()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView(icon: UIImage?, title: String) {
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title
        addSubviews(iconImageView, titleLabel)
    }

    private func updateAppearance() {
        let tintColor: UIColor = isSelected ? .primaryBlueAccent : .textColorGrey
        iconImageView.tintColor = tintColor
        titleLabel.textColor = tintColor
    }
}

// MARK: - Constraints
extension CustomTabBarItem {
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.centerY.equalTo(iconImageView)
        }
    }
}
