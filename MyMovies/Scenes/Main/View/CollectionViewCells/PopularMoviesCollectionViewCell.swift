//
//  PopularMoviesCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/08/2024.
//

import UIKit

final class PopularMoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularMoviesCollectionViewCell"

    // MARK: - UIComponents
    // Main view area
    private let imageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 8
    )
    private let captionView: UIView = .createCommonView(cornderRadius: 5, backgroundColor: .primarySoft)
    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
        numberOfLines: 2,
        textColor: .textColorWhite
    )
    // Genres
    private let genreLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorGrey
    )
    private lazy var ratingView: UIStackView = createUIStackView()
    private let ratingIconImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFit,
        image: UIImage(systemName: "star.fill")?.withTintColor(.secondaryOrange, renderingMode: .alwaysOriginal)
    )
    private let ratingLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
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

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        genreLabel.text = nil
        ratingLabel.text = nil
    }

    // MARK: - Public
    func configure(with movie: MovieProtocol) {
        let posterURL = URL(string: movie.poster?.url ?? "")
        imageView.kf.setImage(with: posterURL, placeholder: Asset.DefaultCovers.defaultPoster.image)

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
            captionView,
            ratingView
        )
        ratingView.addArrangedSubview(ratingIconImageView)
        ratingView.addArrangedSubview(ratingLabel)
        captionView.addSubviews(titleLabel, genreLabel)
    }
}

// MARK: - Helpers
extension PopularMoviesCollectionViewCell {
    private func createUIStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4

        stackView.backgroundColor = .primarySoft.withAlphaComponent(0.8)
        stackView.layer.cornerRadius = 8

        return stackView
    }
}

// MARK: - Constraints
extension PopularMoviesCollectionViewCell {
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.5)
        }

        captionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.equalToSuperview().offset(8)
        }

        // Calculate the height for two lines of text
        let titleHeight = titleLabel.font.lineHeight * 2 + 4
        genreLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.equalTo(titleLabel.snp.top).offset(titleHeight)
        }

        ratingView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }

        ratingIconImageView.snp.makeConstraints { make in
            make.height.equalTo(ratingLabel.snp.height)
            make.width.equalTo(ratingIconImageView.snp.height)
        }
    }
}
