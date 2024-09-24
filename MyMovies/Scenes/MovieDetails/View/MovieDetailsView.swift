//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsView: UIView, MovieDetailsViewProtocol {
    var presenter: MovieDetailsPresenterProtocol?

    // Story line “Read More” functionality preferences
    private var isExpanded = false
    private var fullTextHeight: CGFloat = 0
    private let maxLines = 5

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var backdropImageView: UIImageView = createBackdropImageView()
    private let posterImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 12
    )
    private let descriptionStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 8,
        distribution: .fillProportionally,
        alignment: .fill
    )
    private let firstSeparatorView: UIView = .createCommonView(backgroundColor: .textColorGrey)
    private let secondSeparatorView: UIView = .createCommonView(backgroundColor: .textColorGrey)
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
    // Rating
    private let ratingStackView = RatingGeneralStackView()
    // Buttons section
    private let buttonsStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 48,
        distribution: .fillProportionally,
        alignment: .fill
    )
    private lazy var trailerButton: UIButton = createTrailerButton()
    private lazy var shareButton: UIButton = createShareButton()
    // Story line section
    private let storyLineLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhite,
        text: "Story Line"
    )
    private lazy var storyTextView: UITextView = createStoryTextView()
    private lazy var readMoreButton: UIButton = createReadMoreButton()

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
    override func layoutSubviews() {
        super.layoutSubviews()
        // Adjust the size of the background gradient layer
        backdropImageView.layer.sublayers?.first?.frame = backdropImageView.bounds
        
        // Preset
        let text = "For the first time in the cinematic history of Spider-Man, our friendly neighborhood hero's identity is revealed, bringing his Super Hero responsibilities into conflict with his normal life and putting those he cares about most at risk. A new line text the cinematic history of Spider-Man, our friendly neighborhood hero's identity is revealed end the new line"
        self.configure(with: text)
        // Preset
    }

    // MARK: - Public
    func configure(with text: String) {
        storyTextView.text = text
        storyTextView.layoutIfNeeded()
        updateButtonVisibility()
    }
}

// MARK: - Setup
extension MovieDetailsView {
    private func setupView() {
        backgroundColor = .primaryBackground

        addSubviews(backdropImageView, scrollView)
        scrollView.addSubviews(contentView)
        scrollView.showsVerticalScrollIndicator = false

        contentView.addSubviews(posterImageView)
        contentView.addSubviews(descriptionStackView)
        contentView.addSubviews(ratingStackView)
        contentView.addSubviews(buttonsStackView)
        contentView.addSubviews(storyLineLabel)
        contentView.addSubviews(storyTextView)
        contentView.addSubviews(readMoreButton)
        // Description section arrangement
        descriptionStackView.addArrangedSubview(yearStackView)
        descriptionStackView.addArrangedSubview(firstSeparatorView)
        descriptionStackView.addArrangedSubview(runtimeStackView)
        descriptionStackView.addArrangedSubview(secondSeparatorView)
        descriptionStackView.addArrangedSubview(genreStackView)
        // Buttons
        buttonsStackView.addArrangedSubview(trailerButton)
        buttonsStackView.addArrangedSubview(shareButton)

        // Preset
        posterImageView.image = Asset.DefaultCovers.defaultPoster.image
        yearStackView.label.text = "2021"
        runtimeStackView.label.text = "95 Minutes"
        genreStackView.label.text = "Thriller"
        ratingStackView.ratingLabel.text = "5.5"
        // Preset
    }
}

// MARK: - Private
extension MovieDetailsView {
    private func updateButtonVisibility() {
        let fullSize = storyTextView.sizeThatFits(CGSize(width: storyTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
        fullTextHeight = fullSize.height
        readMoreButton.isHidden = fullTextHeight <= storyTextView.frame.height
    }
}

// MARK: - ActionMethods
extension MovieDetailsView {
    @objc
    private func readMoreTapped(_ sender: UIButton) {
        debugPrint("Read more tapped")
        isExpanded.toggle()
        storyTextView.snp.updateConstraints { make in
            make.height.equalTo(isExpanded ? calculateContentHeight(lines: maxLines) : fullTextHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        readMoreButton.setTitle(isExpanded ? "Less" : "More", for: .normal)
    }
}

// MARK: - Helpers
extension MovieDetailsView {
    private func createBackdropImageView() -> UIImageView {
        let imageView: UIImageView = .createImageView(contentMode: .scaleAspectFill, image: Asset.DefaultCovers.defaultBackdrop.image)
        let gradientLayer = CAGradientLayer()

        // Transparent color
        gradientLayer.colors = [
            UIColor.primaryBackground.withAlphaComponent(0.9).cgColor,
            UIColor.primaryBackground.withAlphaComponent(0.95).cgColor
        ]
        gradientLayer.locations = [0.0, 0.7]
        imageView.layer.insertSublayer(gradientLayer, at: 0)

        return imageView
    }

    private func createTrailerButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Trailer", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 20)
        let config = UIImage.SymbolConfiguration(scale: .small)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.backgroundColor = .secondaryOrange
        button.tintColor = .textColorWhite
        button.layer.cornerRadius = 25
        button.titleLabel?.font = Typography.Medium.title

        return button
    }

    private func createShareButton() -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .primarySoft
        button.setImage(Asset.Icons.share.image, for: .normal)
        button.tintColor = .primaryBlueAccent
        button.layer.cornerRadius = 25

        return button
    }

    private func createStoryTextView() -> UITextView {
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

    private func createReadMoreButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("More", for: .normal)
        button.setTitleColor(.primaryBlueAccent, for: .normal)
        button.titleLabel?.font = Typography.Regular.title
        button.backgroundColor = .clear
        button.isHidden = true
        button.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)

        return button
    }

    // Calculate the initial content hight for the story text view
    private func calculateContentHeight(lines: Int) -> CGFloat {
        storyTextView.layoutIfNeeded()
        let lineHeight = storyTextView.font?.lineHeight ?? 0

        return lineHeight * CGFloat(lines)
    }
}

// MARK: - Constraints
extension MovieDetailsView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupMainElementsConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    private func setupMainElementsConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }

        posterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(posterImageView.snp.width).dividedBy(0.675) // 2:3 aspect ratio of movie posters
        }
        // Description stack
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        firstSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(20)
        }

        secondSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(20)
        }

        ratingStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionStackView.snp.bottom).offset(16)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        // Buttons
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ratingStackView.snp.bottom).offset(16)
            make.height.equalTo(50)
        }

        trailerButton.snp.makeConstraints { make in
            make.width.equalTo(130)
        }

        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        // Story line
        storyLineLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(trailerButton.snp.bottom).offset(16)
        }

        storyTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(storyLineLabel.snp.bottom).offset(8)
            make.height.equalTo(calculateContentHeight(lines: maxLines))
        }

        readMoreButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(storyTextView.snp.bottom)
            make.height.equalTo(20)
        }
    }
}
