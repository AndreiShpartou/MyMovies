//
//  CategoryCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"

    private let categoryLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textAlignment: .center,
        textColor: .textColorWhiteGrey
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

    // MARK: - Public
    func configure(with text: String) {
        categoryLabel.text = text
    }
}

// MARK: - Setup
extension CategoryCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(categoryLabel)
        contentView.backgroundColor = .primaryBackground
        contentView.layer.cornerRadius = 8
    }
}

// MARK: - Constraints
extension CategoryCollectionViewCell {
    private func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
