//
//  PopularMoviesCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import UIKit

final class PopularMoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularMoviesCollectionViewCell"

    private let imageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 8
    )

    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
        textColor: .textColorWhite
    )

    private let genreLabel: UILabel = .createLabel(
        font: Typography.Medium.caption,
        textColor: .textColorGrey
    )

    private let ratingView: UIView = .createCommonView(
        cornderRadius: 4,
        backgroundColor: .primarySoft
    )

    private let ratingLabel: UILabel = .createLabel(
        font: Typography.SemiBold.body,
        textColor: .secondaryOrange
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

        imageView.image = nil
        titleLabel.text = nil
        genreLabel.text = nil
        ratingLabel.text = nil
    }

    // MARK: - Public
    func configure(with movie: MovieProtocol) {

        if  let coverString = movie.poster?.url,
            let coverURL = URL(string: coverString) {
            imageView.kf.setImage(with: coverURL)
        }
        titleLabel.text = movie.title
        genreLabel.text = movie.genres.first?.name
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0)
    }
}

// MARK: - Setup
extension PopularMoviesCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(
            imageView,
            titleLabel,
            genreLabel,
            ratingView
        )
        ratingView.addSubviews(ratingLabel)
    }
}

// MARK: - Constraints
extension PopularMoviesCollectionViewCell {
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(imageView.snp.bottom).offset(8)
        }

        genreLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        ratingView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(24)
            make.height.equalTo(40)
        }

        ratingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
