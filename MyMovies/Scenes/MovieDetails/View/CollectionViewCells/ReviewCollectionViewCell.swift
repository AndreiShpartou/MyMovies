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

    private lazy var reviewTextView: UITextView = createReviewTextView()

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

    func configure(with review: ReviewViewModelProtocol) {
        authorLabel.text = review.author
        reviewTextView.text = review.review
    }
}

// MARK: - Setup
extension ReviewCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(authorLabel, reviewTextView)
    }
}

// MARK: - Helpers
extension ReviewCollectionViewCell {
    private func createReviewTextView() -> UITextView {
        let textView = UITextView()
        textView.font = Typography.Regular.title
        textView.textColor = .textColorWhiteGrey
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        return textView
    }
}

// MARK: - Constraints
extension ReviewCollectionViewCell {
    private func setupConstraints() {
        authorLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
        }
        reviewTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
