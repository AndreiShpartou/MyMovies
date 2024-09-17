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
    private lazy var countriesRowStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 8,
        distribution: .fill
    )
    // Title
    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        numberOfLines: 2,
        textColor: .textColorWhite
    )
    private let yearLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorGrey
    )
    private let runtimeLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        textColor: .textColorGrey
    )
    private let genreLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
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
        configureCountries(countries: movie.countries)
    }
}

// MARK: - Setup
extension MovieListCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(posterImageView, ratingStackView, descriptionStackView)
        posterImageView.addSubviews(ratingStackView)
        descriptionStackView.addArrangedSubview(titleLabel)
        descriptionStackView.addArrangedSubview(yearLabel)
        // Add runtime description for up-to-date devices
        if UIScreen.main.bounds.size.width > 320 {
            descriptionStackView.addArrangedSubview(runtimeLabel)
        }
        descriptionStackView.addArrangedSubview(genreLabel)
        descriptionStackView.addArrangedSubview(countriesRowStackView)
    }
}

// MARK: - Helpers
extension MovieListCollectionViewCell {
    private func createCountryView(labelText: String?) -> UIView {
        let view: UIView = .createCommonView(cornderRadius: 8)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.primaryBlueAccent.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false

        let label: UILabel = .createLabel(
            font: Typography.Medium.body,
            textColor: .primaryBlueAccent,
            text: labelText
        )

        // Arrangment
        view.addSubviews(label)
        view.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        return view
    }

    private func configureCountries(countries: [CountryProtocol]) {
        countries.forEach {
            guard countriesRowStackView.arrangedSubviews.count < 2 else {
                return
            }

            countriesRowStackView.addArrangedSubview(createCountryView(labelText: $0.name))
        }
        // add an empty stretchable view to the right
        let stretchableView: UIView = .createCommonView()
        stretchableView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        countriesRowStackView.addArrangedSubview(stretchableView)
    }
}

// MARK: - Constraints
extension MovieListCollectionViewCell {
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        ratingStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }

        descriptionStackView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(posterImageView).offset(16)
            make.bottom.lessThanOrEqualTo(posterImageView).inset(16)
        }
    }
}
