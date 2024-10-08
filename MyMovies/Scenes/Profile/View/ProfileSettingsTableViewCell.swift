//
//  ProfileSettingsTableViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/10/2024.
//

import UIKit

final class ProfileSettingsTableViewCell: UITableViewCell {
    static let identifier = "ProfileSettingsTableViewCell"

    // MARK: - UIComponents
    private let iconImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        clipsToBounds: true,
        cornerRadius: 12
    )

    private let titleLabel: UILabel = .createLabel(
        font: Typography.Medium.title,
        textColor: .textColorWhite
    )

    private let chevronImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        image: UIImage(systemName: "chevron.right")?.withTintColor(.primaryBlueAccent)
    )

    private let separatorView: UIView = .createCommonView(backgroundColor: .separator)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        titleLabel.text = nil
    }

    // MARK: - Public
    func configure(with item: ProfileSettingsItemViewModelProtocol) {
        iconImageView.image = item.icon
        titleLabel.text = item.title
    }
}

// MARK: - Setup
extension ProfileSettingsTableViewCell {
    private func setupView() {
        contentView.backgroundColor = .primaryBackground
        contentView.addSubviews(iconImageView, titleLabel, chevronImageView, separatorView)
        accessoryType = .none
        selectionStyle = .default
    }
}

// MARK: - Constraints
extension ProfileSettingsTableViewCell {
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(13)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
