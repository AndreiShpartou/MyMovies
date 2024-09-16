//
//  MovieListCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/09/2024.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieListCollectionViewCell"

    // MARK: - UIComponents
    // Poster image
    private let posterImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 8
    )
    // Rating
    private let ratingStackView = RatingGeneralStackView()
    // Description section
    private let descriptionStackView: UIStackView = .createCommonStackView(
        axis: .vertical,
        spacing: 16
    )
    private lazy var descriptionRowStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 8
    )
    // Title
    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        numberOfLines: 2,
        textColor: .textColorWhite
    )
    private let yearLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorGrey
    )
    private let runtimeLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorGrey
    )
    private let ageRestrictionLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .primaryBlueAccent
    )
    private let genreLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorGrey
    )
    private let typeLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
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
    func configure(with movie: MovieProtocol) {
    }
}

// MARK: - Setup
extension MovieListCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(posterImageView, ratingStackView, descriptionStackView)
        posterImageView.addSubviews(ratingStackView)
    }
}

// MARK: - Helpers
extension MovieListCollectionViewCell {
}

// MARK: - Constraints
extension MovieListCollectionViewCell {
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        ratingStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }
}
