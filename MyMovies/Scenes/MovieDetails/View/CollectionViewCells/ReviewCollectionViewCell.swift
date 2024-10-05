//
//  ReviewCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/10/2024.
//

import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReviewCollectionViewCell"

    // MARK: - UIComponents
    private let authorLabel: UILabel = .createLabel(
        font: Typography.SemiBold.subhead,
        textColor: .textColorWhiteGrey
    )

    private let reviewTextView: UITextView = .createCommonTextView(isUserInteractionEnabled: false)

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

        authorLabel.text = nil
        reviewTextView.text = nil
    }

    // MARK: - Public
    func configure(with review: ReviewViewModelProtocol) {
        authorLabel.text = review.author
        // TMDB sends a string with html tags
        if let attrubitedText = review.review.convertHtmlToAttributedString(
            font: Typography.Regular.title,
            textColor: .textColorWhiteGrey
        ) {
            reviewTextView.attributedText = attrubitedText
        } else {
            reviewTextView.text = review.review
        }
    }
}

// MARK: - Setup
extension ReviewCollectionViewCell {
    private func setupView() {
        backgroundColor = .primarySoft
        layer.cornerRadius = 12
        contentView.addSubviews(authorLabel, reviewTextView)
    }
}

// MARK: - Constraints
extension ReviewCollectionViewCell {
    private func setupConstraints() {
        authorLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        authorLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(20) // Ensure there is a minimum height
        }
        reviewTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-8)
            make.height.greaterThanOrEqualTo(40).priority(.low) // Minimum height to avoid ambiguity
        }
    }
}
