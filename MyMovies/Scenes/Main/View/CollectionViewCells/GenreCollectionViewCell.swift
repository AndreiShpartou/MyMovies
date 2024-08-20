//
//  GenreCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import UIKit
import SnapKit

final class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"

    private let genreLabel: UILabel = .createLabel(
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

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()

        genreLabel.text = nil
    }

    // MARK: - Public
    func configure(with genre: GenreProtocol) {
        genreLabel.text = genre.name
    }
}

// MARK: - Setup
extension GenreCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(genreLabel)
        contentView.backgroundColor = .primaryBackground
        contentView.layer.cornerRadius = 8
    }
}

// MARK: - Constraints
extension GenreCollectionViewCell {
    private func setupConstraints() {
        genreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
