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

    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
        numberOfLines: 2,
        textColor: .textColorWhite
    )

    private let ratingStackView = RatingGeneralStackView()
    private let favouriteButton: UIButton = .createFavouriteButton()

    // MARK: - Init
    init() {
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
    }

    // MARK: - Public
    func configure(with movie: WishlistItemViewModelProtocol) {
        self.movieID = movie.id
        posterImageView.kf.setImage(with: movie.posterURL, placeholder: Asset.DefaultCovers.defaultPoster.image)
        titleLabel.text = movie.title
        genreLabel.text = movie.genre
        ratingStackView.ratingLabel.text = movie.voteAverage
    }
}

// MARK: - Setup
extension WishlistCollectionViewCell {
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            posterImageView,
            genreLabel,
            titleLabel,
            ratingStackView,
            favouriteButton
        )
        // Set targets
        favouriteButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    }
}

// MARK: - ActionMethods
extension WishlistCollectionViewCell {
    @objc
    private func didTapRemoveButton() {
        guard let movieID = movieID else { return }
        delegate?.didTapRemoveButton(for: movieID)
    }
}

// MARK: - Constraints
extension WishlistCollectionViewCell {
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.675) // 2:3 aspect ratio of movie posters
        }

        genreLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(4)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalTo(genreLabel.snp.bottom).offset(4)
        }

        ratingStackView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }

        favouriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.top.centerY.equalTo(ratingStackView)
            make.width.height.equalTo(32)
        }
    }
}
