//
//  RatingGeneralStackView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/09/2024.
//

import UIKit

final class RatingGeneralStackView: UIStackView {
    let ratingLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
        textColor: .secondaryOrange
    )

    private let ratingIconImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        image: UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.secondaryOrange, renderingMode: .alwaysOriginal)
    )

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension RatingGeneralStackView {
    private func setupView() {
        axis = .horizontal
        distribution = .fill
        alignment = .fill
        spacing = 4

        backgroundColor = .primarySoft.withAlphaComponent(0.8)
        layer.cornerRadius = 8

        addArrangedSubview(ratingIconImageView)
        addArrangedSubview(ratingLabel)
    }
}

// MARK: - Constraints
extension RatingGeneralStackView {
    private func setupConstraints() {
        ratingIconImageView.snp.makeConstraints { make in
            make.height.equalTo(ratingLabel.snp.height)
            make.width.equalTo(ratingIconImageView.snp.height)
        }
    }
}
