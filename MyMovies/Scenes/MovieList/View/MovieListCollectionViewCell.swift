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
    private lazy var countriesRowStackView: UIStackView = .createCommonStackView(
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
    private let genreLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
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

        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
        runtimeLabel.text = nil
        genreLabel.text = nil
        ratingStackView.ratingLabel.text = nil
        // remove countries subviews
        countriesRowStackView.arrangedSubviews.forEach {
            countriesRowStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    // MARK: - Public
    func configure(with movie: MovieProtocol) {
        posterImageView.kf.setImage(
            with: URL(string: movie.poster?.url ?? ""),
            placeholder: Asset.DefaultCovers.defaultPoster.image
        )
        ratingStackView.ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0)
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseYear
        runtimeLabel.text = movie.runtime
        genreLabel.text = movie.genres.first?.name
        // countries layout
        movie.countries.forEach { country in
            countriesRowStackView.addArrangedSubview(createCountryView(labelText: country.name))
        }
    }
}

// MARK: - Setup
extension MovieListCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(posterImageView, ratingStackView, descriptionStackView)
        posterImageView.addSubviews(ratingStackView)
        descriptionStackView.addArrangedSubview(titleLabel)
        descriptionStackView.addArrangedSubview(yearLabel)
        descriptionStackView.addArrangedSubview(descriptionRowStackView)
        descriptionStackView.addArrangedSubview(countriesRowStackView)
        descriptionRowStackView.addArrangedSubview(runtimeLabel)
        descriptionRowStackView.addArrangedSubview(genreLabel)
    }
}

// MARK: - Helpers
extension MovieListCollectionViewCell {
    private func createCountryView(labelText: String?) -> UIView {
        let view: UIView = .createCommonView(cornderRadius: 8, backgroundColor: .clear)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.primaryBlueAccent.cgColor

        let label: UILabel = .createLabel(
            font: Typography.Medium.body,
            textColor: .primaryBlueAccent,
            text: labelText
        )

        // Arrangment
        view.addSubviews(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        return view
    }
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

        descriptionStackView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.top.bottom.equalTo(posterImageView).inset(16)
        }
    }
}
