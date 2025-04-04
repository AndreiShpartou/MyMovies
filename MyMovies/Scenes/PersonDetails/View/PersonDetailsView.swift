//
//  PersonDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import UIKit
import SnapKit

final class PersonDetailsView: UIView, PersonDetailsViewProtocol {
    var delegate: PersonDetailsViewDelegate? {
        didSet {
            updateDelegates()
        }
    }

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // Loading indicators
    private let mainViewLoadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)
    private let genresLoadingIndicator: UIActivityIndicatorView = .createSpinner(style: .medium)
    private let relatedMoviesLoadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)

    // Header section
    private let personImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 12
    )

    private let nameLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        numberOfLines: 0,
        textColor: .textColorWhite
    )

    private let birthInfoLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        numberOfLines: 0,
        textColor: .textColorGrey
    )

    private let departmentLabel: UILabel = .createLabel(
        font: Typography.Medium.subhead,
        numberOfLines: 0,
        textColor: .textColorGrey
    )

    // Genres collection
    private let genresLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Genres"
    )

    private let genresCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 100, height: 40),
        cellTypesDict: [GenreCollectionViewCell.identifier: GenreCollectionViewCell.self]
    )
    private lazy var genresCollectionViewHandler = GenresCollectionViewHandler()

    // Related movies section
    private let relatedMoviesLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textColor: .textColorWhite,
        text: "Related Movies"
    )

    private lazy var seeAllButton: UIButton = .createSeeAllButton(
        action: #selector(didTapSeeAllButton),
        target: self
    )

    private let relatedMoviesCollectionView: UICollectionView = .createCommonCollectionView(
        itemSize: CGSize(width: 150, height: 300),
        cellTypesDict: [
            BriefMovieDescriptionCollectionViewCell.identifier: BriefMovieDescriptionCollectionViewCell.self,
            PlaceHolderCollectionViewCell.identifier: PlaceHolderCollectionViewCell.self
        ],
        scrollDirection: .horizontal
    )
    private lazy var relatedMoviesCollectionViewHandler = BriefMovieDescriptionHandler()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PersonDetailsViewProtocol
    func showPersonDetails(_ person: PersonDetailedViewModelProtocol) {
        // photo
        personImageView.kf.setImage(with: person.photo, placeholder: Asset.DefaultCovers.defaultPerson.image)
        // details
        nameLabel.text = person.name
        var birthInfo: String = ""
        if let birthDay = person.birthDay, birthDay != "" {
            birthInfo += "Born: \(birthDay)"
        }
        if let birthPlace = person.birthPlace, birthPlace != "" {
            birthInfo += "\nPlace of Birth: \(birthPlace)"
        }
        if let deathDay = person.deathDay, deathDay != "" {
            birthInfo += "\nDied: \(deathDay)"
        }
        birthInfoLabel.text = birthInfo
        departmentLabel.text = person.department
    }

    func showMovieGenres(_ genres: [GenreViewModelProtocol]) {
        genresCollectionViewHandler.configure(with: genres)
        genresCollectionView.reloadData()

        setupAdditionalDefaultPreferences()
    }

    func showPersonRelatedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        relatedMoviesCollectionViewHandler.configure(with: movies)
        relatedMoviesCollectionView.reloadData()
    }

    func setLoadingIndicator(for section: MainAppSection, isVisible: Bool) {
        switch section {
        case .rootView:
            toggleLoader(mainViewLoadingIndicator, isVisible: isVisible)
        case .genres:
            toggleLoader(genresLoadingIndicator, isVisible: isVisible)
        case .relatedMovies:
            toggleLoader(relatedMoviesLoadingIndicator, isVisible: isVisible)
        default:
            break
        }
    }

    func showError(_ error: Error) {
        guard let viewController = parentViewController else {
            return
        }

        // Present an alert to the user
        let alert = getGlobalAlertController(for: error.localizedDescription)
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup
extension PersonDetailsView {
    private func setupView() {
        backgroundColor = .primaryBackground

        addSubviews(scrollView, mainViewLoadingIndicator)
        scrollView.addSubviews(contentView)
        scrollView.showsVerticalScrollIndicator = false

        contentView.addSubviews(
            personImageView,
            nameLabel,
            birthInfoLabel,
            departmentLabel,
            genresLabel,
            genresCollectionView,
            relatedMoviesLabel,
            seeAllButton,
            relatedMoviesCollectionView
        )

        // Loading indicators
        genresCollectionView.addSubviews(genresLoadingIndicator)
        relatedMoviesCollectionView.addSubviews(relatedMoviesLoadingIndicator)

        // Handlers
        setupHandlers()
    }

    private func setupHandlers() {
        // peron related movies
        relatedMoviesCollectionView.dataSource = relatedMoviesCollectionViewHandler
        relatedMoviesCollectionView.delegate = relatedMoviesCollectionViewHandler
        // genres
        genresCollectionView.dataSource = genresCollectionViewHandler
        genresCollectionView.delegate = genresCollectionViewHandler
    }

    func updateDelegates() {
        relatedMoviesCollectionViewHandler.delegate = delegate
        genresCollectionViewHandler.delegate = delegate
    }

    private func setupAdditionalDefaultPreferences() {
        // Default selection of the first item
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        genresCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
        genresCollectionViewHandler.collectionView(genresCollectionView, didSelectItemAt: defaultIndexPath)
    }
}

// MARK: - ActionMethods
extension PersonDetailsView {
    @objc
    private func didTapSeeAllButton() {
        delegate?.didTapSeeAllButton()
    }
}

// MARK: - Helpers
extension PersonDetailsView {
    private func toggleLoader(_ loader: UIActivityIndicatorView, isVisible: Bool) {
        if isVisible {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }
}

// MARK: - Constraints
extension PersonDetailsView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupHeaderConstraints()
        setupMainConstraints()
        setupOtherConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.bottom.equalTo(relatedMoviesCollectionView).offset(16)
        }
    }

    private func setupHeaderConstraints() {
        personImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8 / 2)
            make.height.equalTo(personImageView.snp.width).multipliedBy(1.5)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(personImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(personImageView)
        }

        birthInfoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }

        departmentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(birthInfoLabel.snp.bottom).offset(16)
        }
    }

    private func setupMainConstraints() {
        genresLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(personImageView.snp.bottom).offset(24)
        }

        genresCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(genresLabel.snp.bottom).offset(16)
            make.height.equalTo(40)
        }

        relatedMoviesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(genresCollectionView.snp.bottom).offset(24)
        }

        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(relatedMoviesLabel)
        }

        relatedMoviesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.equalTo(relatedMoviesLabel.snp.bottom).offset(8)
            make.height.equalTo(300)
        }
    }

    private func setupOtherConstraints() {
        // Loading indicators
        mainViewLoadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        genresLoadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        relatedMoviesLoadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
