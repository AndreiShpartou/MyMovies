//
//  MovieListsCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import UIKit
import Kingfisher

final class UpcomingMoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "UpcomingMoviesCollectionViewCell"

    private let backdropImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true
    )

    private lazy var posterImageView: UIImageView = createPosterImageView()

    private lazy var captionView: UIView = createCaptionView()

    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        numberOfLines: 2,
        textColor: .textColorWhite
    )

    private let shortDescriptionLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        numberOfLines: 0,
        textColor: .textColorGrey
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

        backdropImageView.image = nil
        posterImageView.image = nil
        titleLabel.text = nil
        shortDescriptionLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        captionView.layer.sublayers?.first?.frame = captionView.bounds
    }

    // MARK: - Public
    func configure(with movie: MovieProtocol) {
        if let backdropURLString = movie.backdrop?.url,
           let backdropURL = URL(string: backdropURLString) {
            backdropImageView.kf.setImage(with: backdropURL)
        } else {
            backdropImageView.image = Asset.DefaultCovers.defaultBackdrop.image
        }

        if let posterURLString = movie.poster?.url,
           let posterURL = URL(string: posterURLString) {
            posterImageView.kf.setImage(with: posterURL)
        } else {
            posterImageView.image = Asset.DefaultCovers.defaultPoster.image
        }

        titleLabel.text = movie.title
        shortDescriptionLabel.text = movie.shortDescription
    }
}

// MARK: - Setup
extension UpcomingMoviesCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(
            backdropImageView,
            captionView,
            posterImageView,
            titleLabel,
            shortDescriptionLabel
        )
    }
}

// MARK: - Helpers
extension UpcomingMoviesCollectionViewCell {
    private func createPosterImageView() -> UIImageView {
        let imageView: UIImageView = .createImageView(
            contentMode: .scaleAspectFill,
            clipsToBounds: true
        )
        imageView.layer.borderColor = UIColor.primarySoft.cgColor
        imageView.layer.borderWidth = 3.0

        return imageView
    }

    private func createCaptionView() -> UIView {
        let view: UIView = .createCommonView(backgroundColor: .clear)
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
            UIColor.clear.cgColor, // Transparent color
            UIColor.primaryBlack.cgColor
        ]
        gradientLayer.locations = [0.0, 0.7]
        view.layer.insertSublayer(gradientLayer, at: 0)

        return view
    }
}

// MARK: - Constraints
extension UpcomingMoviesCollectionViewCell {
    private func setupConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(contentView.snp.height).multipliedBy(0.75)
        }

        captionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backdropImageView.snp.centerY)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(backdropImageView.snp.centerY).offset(-16)
            make.bottom.equalTo(captionView.snp.bottom).offset(-16)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.675) // 2:3 aspect ratio of movie posters
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-8)
            make.centerY.equalTo(captionView.snp.centerY).multipliedBy(1.1)
        }

        shortDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}
