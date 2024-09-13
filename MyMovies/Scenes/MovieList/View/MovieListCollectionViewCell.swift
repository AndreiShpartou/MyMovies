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
    // Title
    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        numberOfLines: 2,
        textColor: .textColorWhite
    )
    // Rating
//    private lazy var ratingView: UIStackView = createUIStackView()
//    private let ratingIconImageView: UIImageView = .createImageView(
//        contentMode: .scaleAspectFit,
//        image: UIImage(systemName: "star.fill")?.withTintColor(.secondaryOrange, renderingMode: .alwaysOriginal)
//    )
//    private let ratingLabel: UILabel = .createLabel(
//        font: Typography.SemiBold.subhead,
//        textColor: .secondaryOrange
//    )
    // Movie description section
//    private let descriptionStackView: UIStackView

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
    }
}

// MARK: - Helpers
extension MovieListCollectionViewCell {
}

// MARK: - Constraints
extension MovieListCollectionViewCell {
    private func setupConstraints() {
    }
}
