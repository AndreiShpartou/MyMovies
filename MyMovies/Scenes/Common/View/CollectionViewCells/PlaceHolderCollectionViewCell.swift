//
//  PlaceHolderCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/10/2024.
//

import UIKit

class PlaceHolderCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaceHolderCollectionViewCell"

    // MARK: - UIComponents
    private let messageLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhiteGrey
    )
    private let placeholderImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill
    )

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        placeholderImageView.image = nil
        messageLabel.text = nil
    }

    // MARK: - Public
    func configure(
        with image: UIImage?,
        and message: String?,
        backgroundColor: UIColor? = .primarySoft
    ) {
        placeholderImageView.image = image
        messageLabel.text = message
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Setup
extension PlaceHolderCollectionViewCell {
    private func setupView() {
        layer.cornerRadius = 15
        contentView.addSubviews(messageLabel, placeholderImageView)
    }
}

// MARK: - Constraints
extension PlaceHolderCollectionViewCell {
    private func setupConstraints() {
        placeholderImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY)
            make.width.equalTo(80)
            make.height.lessThanOrEqualTo(80)
        }

        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeholderImageView.snp.bottom).offset(16)
        }
    }
}
