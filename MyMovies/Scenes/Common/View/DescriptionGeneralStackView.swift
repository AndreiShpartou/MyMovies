//
//  DescriptionGeneralStackView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 23/09/2024.
//

import UIKit

final class DescriptionGeneralStackView: UIStackView {
    let imageView: UIImageView = .createImageView(contentMode: .scaleAspectFit)
    let label: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorGrey
    )

    // MARK: - Init
    init(image: UIImage?) {
        super.init(frame: .zero)

        imageView.image = image

        setupView()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension DescriptionGeneralStackView {
    private func setupView() {
        axis = .horizontal
        distribution = .fill
        alignment = .fill
        spacing = 4
        backgroundColor = .clear

        addArrangedSubview(imageView)
        addArrangedSubview(label)
    }
}

// MARK: - Constraints
extension DescriptionGeneralStackView {
    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(imageView.image?.size.width ?? 0)
        }
    }
}
