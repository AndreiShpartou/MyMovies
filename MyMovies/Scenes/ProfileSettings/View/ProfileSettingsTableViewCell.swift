//
//  ProfileSettingsTableViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 07/10/2024.
//

import UIKit
import SnapKit

final class ProfileSettingsTableViewCell: UITableViewCell {
    static let identifier = "ProfileSettingsTableViewCell"

    // MARK: - UIComponents
    private var bottomCellConstraint: Constraint?

    // View for rendering borders
    private let commonView: UIView = .createCommonView(backgroundColor: .primaryBackground)

    private let iconImageBackgroundView: UIView = .createCommonView(cornerRadius: 18, backgroundColor: .primarySoft)
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
        image: UIImage(systemName: "chevron.right")?.withTintColor(.primaryBlueAccent, renderingMode: .alwaysOriginal)
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
        separatorView.isHidden = false
        updateBottomBorder()
    }

    // MARK: - Public
    func configure(with item: ProfileSettingsItemViewModelProtocol) {
        iconImageView.image = item.icon?.withTintColor(.textColorGrey)
        titleLabel.text = item.title
    }

    func createBottomBorder() {
        updateBottomBorder(isLastCell: true)
    }

    func setSelectedCustrom(_ selected: Bool, animated: Bool) {
        if selected {
            commonView.backgroundColor = .primarySoft
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.commonView.backgroundColor = .primaryBackground
            }
        }
    }
}

// MARK: - Setup
extension ProfileSettingsTableViewCell {
    private func setupView() {
        backgroundColor = .primaryBackground
        contentView.backgroundColor = .primarySoft
        contentView.addSubviews(commonView)
        commonView.addSubviews(iconImageBackgroundView, titleLabel, chevronImageView, separatorView)
        iconImageBackgroundView.addSubviews(iconImageView)
        accessoryType = .none
        selectionStyle = .none
    }
}

// MARK: - Helpers
extension ProfileSettingsTableViewCell {
    private func updateBottomBorder(isLastCell: Bool = false) {
        if isLastCell {
            separatorView.isHidden = true
            bottomCellConstraint?.update(inset: 2)
            commonView.layer.cornerRadius = 20
            commonView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            contentView.layer.cornerRadius = 20
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            bottomCellConstraint?.update(inset: 0)
            commonView.layer.cornerRadius = 0
            contentView.layer.cornerRadius = 0
        }
    }
}

// MARK: - Constraints
extension ProfileSettingsTableViewCell {
    private func setupConstraints() {
        commonView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(2)
            bottomCellConstraint = make.bottom.equalToSuperview().constraint
        }

        iconImageBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(25)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageBackgroundView.snp.trailing).offset(16)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.centerX)
            make.trailing.equalTo(chevronImageView.snp.centerX)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
