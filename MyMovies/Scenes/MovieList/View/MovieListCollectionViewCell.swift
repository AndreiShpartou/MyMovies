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
    // Year
    private let yearStackView = DescriptionGeneralStackView(
        image: Asset.Icons.calendar.image.withTintColor(.textColorGrey, renderingMode: .alwaysOriginal)
    )
    // Runtime
    private let runtimeStackView = DescriptionGeneralStackView(
        image: Asset.Icons.clock.image.withTintColor(.textColorGrey, renderingMode: .alwaysOriginal)
    )
    // Genre
    private let genreStackView = DescriptionGeneralStackView(
        image: Asset.Icons.film.image.withTintColor(.textColorGrey, renderingMode: .alwaysOriginal)
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
        yearStackView.label.text = nil
        runtimeStackView.label.text = nil
        genreStackView.label.text = nil
        ratingStackView.ratingLabel.text = nil
        // remove countries subviews
        countriesRowStackView.arrangedSubviews.forEach {
            countriesRowStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    // MARK: - Public
    func configure(with movie: MovieListItemViewModelProtocol) {
        posterImageView.kf.setImage(with: movie.posterURL, placeholder: Asset.DefaultCovers.defaultPoster.image)
        ratingStackView.ratingLabel.text = movie.voteAverage
        titleLabel.text = movie.title
        yearStackView.label.text = movie.releaseYear
        runtimeStackView.label.text = movie.runtime
        genreStackView.label.text = movie.genre
        // countries layout
        configureCountries(countries: movie.countries)
    }
}

// MARK: - Setup
extension MovieListCollectionViewCell {
    private func setupView() {
        // Poster
        posterImageView.addSubviews(ratingStackView)
        // Description
        descriptionStackView.addArrangedSubview(titleLabel)
        descriptionStackView.addArrangedSubview(yearStackView)
        // Add runtime description for up-to-date devices
        if UIScreen.main.bounds.size.width > 320 {
            descriptionStackView.addArrangedSubview(runtimeStackView)
        }
        descriptionStackView.addArrangedSubview(genreStackView)
        descriptionStackView.addArrangedSubview(countriesRowStackView)

        contentView.addSubviews(posterImageView, descriptionStackView)
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

    private func configureCountries(countries: [String]) {
        countries.forEach {
            guard countriesRowStackView.arrangedSubviews.count < 2 else {
                return
            }

            countriesRowStackView.addArrangedSubview(createCountryView(labelText: $0))
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
            make.top.equalTo(posterImageView).offset(8)
            make.bottom.lessThanOrEqualTo(posterImageView).inset(8)
        }

        yearStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        runtimeStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        genreStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
}
