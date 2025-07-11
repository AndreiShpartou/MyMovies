//
//  WishlistCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/03/2025.
//

import UIKit

protocol WishlistCollectionViewCellDelegate: AnyObject {
    func didTapRemoveButton(for movieID: Int)
}

final class WishlistCollectionViewCell: UICollectionViewCell {
    static let identifier = "WishlistCollectionViewCell"

    weak var delegate: WishlistCollectionViewCellDelegate?

    private var movieID: Int?

    // MARK: - UIComponents
    private let containerView: UIView = .createCommonView(
        cornerRadius: 12,
        backgroundColor: .primarySoft,
        masksToBounds: true
    )

    private let posterImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 8
    )

    private let genreLabel: UILabel = .createLabel(
        font: Typography.Medium.body,
        textColor: .textColorWhite
    )

    private let yearStackView = DescriptionGeneralStackView(
        image: Asset.Icons.calendar.image.withTintColor(.textColorGrey, renderingMode: .alwaysOriginal)
    )

    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
        numberOfLines: 2,
        textColor: .textColorWhite
    )

    private let ratingStackView = RatingGeneralStackView()
    private let favouriteButton: UIButton = .createFavouriteButton(isSelected: true)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()

        movieID = nil
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        titleLabel.text = nil
        genreLabel.text = nil
        ratingStackView.ratingLabel.text = nil
        yearStackView.label.text = nil
        favouriteButton.isSelected = true
        delegate = nil
    }

    // MARK: - Public
    func configure(with movie: WishlistItemViewModelProtocol) {
        applyBlurEffect(to: posterImageView)
        posterImageView.kf.setImage(with: movie.posterURL, placeholder: Asset.DefaultCovers.defaultPoster.image) { [weak self] _ in
            guard let self = self else { return }
            removeBlurEffect(from: self.posterImageView)
        }

        self.movieID = movie.id
        titleLabel.text = movie.title
        genreLabel.text = movie.genre
        ratingStackView.ratingLabel.text = movie.voteAverage
        yearStackView.label.text = movie.year
    }
}

// MARK: - Setup
extension WishlistCollectionViewCell {
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            posterImageView,
            genreLabel,
            favouriteButton,
            titleLabel,
            ratingStackView,
            yearStackView
        )
        // Set targets
        favouriteButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    }
}

// MARK: - ActionMethods
extension WishlistCollectionViewCell {
    @objc
    private func didTapRemoveButton(_ sender: UIButton) {
        guard let movieID = movieID else { return }
        delegate?.didTapRemoveButton(for: movieID)
        sender.isSelected.toggle()
    }
}

// MARK: - Constraints
extension WishlistCollectionViewCell {
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(1.3)
        }

        genreLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.top.equalTo(posterImageView)
        }

        favouriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(genreLabel)
            make.width.height.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(genreLabel.snp.bottom).offset(12)
            make.bottom.lessThanOrEqualTo(ratingStackView.snp.top).offset(-8)
            make.centerY.equalTo(posterImageView).priority(.medium)
        }

        ratingStackView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.bottom.equalTo(posterImageView.snp.bottom)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }

        yearStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(ratingStackView)
            make.height.equalTo(20)
        }
    }
}
