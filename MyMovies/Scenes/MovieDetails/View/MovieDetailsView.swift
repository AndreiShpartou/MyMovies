//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit
import SnapKit

final class MovieDetailsView: UIView, MovieDetailsViewProtocol {
    weak var delegate: MovieDetailsInteractionDelegate?
    var presenter: MovieDetailsPresenterProtocol?

    // Story line “Read More” functionality preferences
    private var isExpanded = false
    private var fullTextHeight: CGFloat = 0
    private let maxLines = 5
    private var constraintToReadMore: Constraint?

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var backdropImageView: UIImageView = createBackdropImageView()
    private let posterImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 12
    )
    private let alternativeTitle: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        numberOfLines: 2,
        textAlignment: .center,
        textColor: .textColorGrey
    )
    private let countriesStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 8,
        distribution: .fill
    )
    private let genresStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 8,
        distribution: .fill
    )
    private let descriptionStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        spacing: 8,
        distribution: .fill,
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
    // Cast and Crew
    private let personsLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhite,
        text: "Cast and Crew"
    )
    private let personsCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 220, height: 60),
        cellType: PersonCollectionViewCell.self,
        reuseIdentifier: PersonCollectionViewCell.identifier,
        minimumLineSpacing: 16
    )
    private let personCollectionViewHandler = PersonCollectionViewHandler()

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
        // Set story text height as needed
        setFullStoryTextHeight()
    }

    // MARK: - Public
    func showDetailedMovie(_ movie: MovieDetailsViewModelProtocol) {
        backdropImageView.kf.setImage(with: movie.backdropURL, placeholder: Asset.DefaultCovers.defaultBackdrop.image)
        posterImageView.kf.setImage(with: movie.posterURL, placeholder: Asset.DefaultCovers.defaultPoster.image)
        alternativeTitle.text = movie.alternativeTitle
        yearStackView.label.text = movie.releaseYear
        runtimeStackView.label.text = movie.runtime
        genreStackView.label.text = movie.genre
        ratingStackView.ratingLabel.text = movie.voteAverage
        storyTextView.text = movie.description
        // Countries
        configureCountries(movie.countries)
        // Genres
        configureGenres(movie.genres)
        // Persons
        configurePersons(movie.persons)
        // delegate
        delegate?.didFetchTitle(movie.title)
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
        contentView.addSubviews(alternativeTitle)
        contentView.addSubviews(countriesStackView)
        contentView.addSubviews(genresStackView)
        contentView.addSubviews(descriptionStackView)
        contentView.addSubviews(ratingStackView)
        contentView.addSubviews(buttonsStackView)
        contentView.addSubviews(storyLineLabel)
        contentView.addSubviews(storyTextView)
        contentView.addSubviews(readMoreButton)
        contentView.addSubviews(personsLabel)
        contentView.addSubviews(personsCollectionView)

        // Description section arrangement
        descriptionStackView.addArrangedSubview(yearStackView)
        descriptionStackView.addArrangedSubview(firstSeparatorView)
        descriptionStackView.addArrangedSubview(runtimeStackView)
        descriptionStackView.addArrangedSubview(secondSeparatorView)
        descriptionStackView.addArrangedSubview(genreStackView)
        // Buttons
        buttonsStackView.addArrangedSubview(trailerButton)
        buttonsStackView.addArrangedSubview(shareButton)
        // Handlers
        personsCollectionView.delegate = personCollectionViewHandler
        personsCollectionView.dataSource = personCollectionViewHandler
    }
}

// MARK: - Private
extension MovieDetailsView {
    private func setFullStoryTextHeight() {
        guard fullTextHeight == 0, storyTextView.frame.size.width != 0 else {
            return
        }

        updateButtonVisibility()
    }

    private func updateButtonVisibility() {
        let fullSize = storyTextView.sizeThatFits(CGSize(width: storyTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
        fullTextHeight = fullSize.height
        let isTextFit = fullTextHeight <= storyTextView.frame.height
        readMoreButton.isHidden = isTextFit
        // Update constraints
        if isTextFit {
            storyTextView.snp.updateConstraints { make in
                make.height.equalTo(fullTextHeight)
            }
            constraintToReadMore?.deactivate()
            personsLabel.snp.makeConstraints { make in
                make.top.equalTo(storyTextView.snp.bottom).offset(16)
            }
        }
    }
}

// MARK: - ActionMethods
extension MovieDetailsView {
    @objc
    private func readMoreTapped(_ sender: UIButton) {
        storyTextView.snp.updateConstraints { make in
            make.height.equalTo(isExpanded ? calculateContentHeight(lines: maxLines) : fullTextHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        isExpanded.toggle()
        readMoreButton.setTitle(isExpanded ? "Less" : "More", for: .normal)
    }
}

// MARK: - Helpers
extension MovieDetailsView {
    private func createBackdropImageView() -> UIImageView {
        let imageView: UIImageView = .createImageView(contentMode: .scaleAspectFill, clipsToBounds: true)
        let gradientLayer = CAGradientLayer()

        // Transparent color
        gradientLayer.colors = [
            UIColor.primaryBackground.withAlphaComponent(0.8).cgColor,
            UIColor.primaryBackground.withAlphaComponent(0.97).cgColor
        ]
        gradientLayer.locations = [0.0, 0.7]
        imageView.layer.insertSublayer(gradientLayer, at: 0)

        return imageView
    }

    private func createTrailerButton() -> UIButton {
        let button = UIButton(type: .system)
        // Creating a configuration for the button
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .secondaryOrange
        config.baseForegroundColor = .textColorWhite
        config.cornerStyle = .capsule
        // Using UIImage.SymbolConfiguration to create the button image
        let symbolConfig = UIImage.SymbolConfiguration(scale: .small)
        config.image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        // Setting the title and adjusting insets
        config.title = "Trailer"
        config.imagePlacement = .leading
        config.imagePadding = 10
        // Applying the configuration to the button
        button.configuration = config
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
        button.isHidden = true
        button.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)

        return button
    }

    // Calculate the initial content hight for the story text view
    private func calculateContentHeight(lines: Int) -> CGFloat {
        storyTextView.layoutIfNeeded()
        let lineHeight = (storyTextView.font?.lineHeight ?? 0).rounded(.up)

        return lineHeight * CGFloat(lines)
    }

    private func configureCountries(_ countries: [CountryViewModelProtocol]) {
        guard !countries.isEmpty else {
            return
        }

        let lastCountry = countries[countries.count - 1]
        countries.forEach { country in
            countriesStackView.addArrangedSubview(UIView.createBorderedViewWithLabel(
                labelText: country.name,
                borderWidth: 0,
                textColor: .textColorGrey
            ))
            // add separator
            if country.name != lastCountry.name {
                let separator: UIView = .createCommonView(backgroundColor: .textColorGrey)
                countriesStackView.addArrangedSubview(separator)
                separator.snp.makeConstraints { make in
                    make.width.equalTo(1.5)
                }
            }
        }
    }

    private func configureGenres(_ movieGenres: [GenreViewModelProtocol]) {
        guard !movieGenres.isEmpty else {
            return
        }

        for (index, genre) in movieGenres.enumerated() {
            if index == 3 {
                break
            }

            genresStackView.addArrangedSubview(UIView.createBorderedViewWithLabel(
                labelText: genre.name,
                borderWidth: 2
            ))
        }
    }

    private func configurePersons(_ moviePersons: [PersonViewModelProtocol]) {
        guard !moviePersons.isEmpty else {
            return
        }

        let persons = moviePersons.sorted {
            $0.photo?.absoluteString ?? "" > $1.photo?.absoluteString ?? ""
        }
        personCollectionViewHandler.configure(with: persons)
        personsCollectionView.reloadData()
    }
}

// MARK: - Constraints
extension MovieDetailsView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupBackgroundConstraints()
        setupHeaderSubViews()
        setupMainDescriptionSubviewsConstraints()
        setupStoryLineConstraints()
        setupPersonsConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    private func setupBackgroundConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }

    private func setupHeaderSubViews() {
        posterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(posterImageView.snp.width).dividedBy(0.675) // 2:3 aspect ratio of movie posters
        }
        alternativeTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
        }
        countriesStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(16)
            make.top.equalTo(alternativeTitle.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        genresStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(16)
            make.top.equalTo(countriesStackView.snp.bottom).offset(8)
            make.height.equalTo(25)
        }
    }

    private func setupMainDescriptionSubviewsConstraints() {
        // Description stack
        descriptionStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(16)
            make.top.equalTo(genresStackView.snp.bottom).offset(16)
            make.height.equalTo(20)
        }

        firstSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(1.5)
        }

        secondSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(1.5)
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
            make.width.equalTo(50)
        }
    }

    private func setupStoryLineConstraints() {
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

    private func setupPersonsConstraints() {
        personsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            constraintToReadMore = make.top.equalTo(readMoreButton.snp.bottom).offset(16).constraint
        }

        personsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(personsLabel.snp.bottom).offset(16)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
