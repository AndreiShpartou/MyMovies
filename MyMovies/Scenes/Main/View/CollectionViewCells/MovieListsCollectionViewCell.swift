//
//  MovieListsCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import UIKit

final class MovieListsCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieListCollectionViewCell"

    private let imageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 8
    )

    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        numberOfLines: 2,
        textColor: .textColorWhite
    )

    private let quantityLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorWhite
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
    func configure(with movieList: MovieList) {
        // imageView.image =
        titleLabel.text = movieList.name
        quantityLabel.text = String(movieList.moviesCount ?? 0)
    }
}

// MARK: - Setup
extension MovieListsCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            quantityLabel
        )
    }
}

// MARK: - Constraints
extension MovieListsCollectionViewCell {
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.centerY.equalToSuperview()
        }

        quantityLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
    }
}
