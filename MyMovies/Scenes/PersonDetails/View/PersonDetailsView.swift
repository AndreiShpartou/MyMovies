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
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)
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
        font: Typography.Medium.body,
        numberOfLines: 0,
        textColor: .textColorGrey
    )
    private let department: UILabel = .createLabel(
        font: Typography.Medium.body,
        numberOfLines: 0,
        textColor: .textColorGrey
    )
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
        itemSize: CGSize(width: 200, height: 400),
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
        personImageView.kf.setImage(with: person.photo, placeholder: Asset.Avatars.avatarDefault.image)
        // details
        nameLabel.text = person.name
        var birthInfo: String = ""
        if let birthDay = person.birthDay {
            birthInfo += "Born: \(birthDay)"
        }
        if let birthPlace = person.birthPlace {
            birthInfo += "\nPlace of Birth: \(birthPlace)"
        }
        if let deathDay = person.deathDay {
            birthInfo += "\nDied: \(deathDay)"
        }
        birthInfoLabel.text = birthInfo
        department.text = person.department
    }

    func showPersonRelatedMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        relatedMoviesCollectionViewHandler.configure(with: movies)
        relatedMoviesCollectionView.reloadData()
    }

    func showLoading() {
        loadingIndicator.startAnimating()
        isUserInteractionEnabled = false
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
        isUserInteractionEnabled = true
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

        addSubviews(scrollView, loadingIndicator)
        scrollView.addSubviews(contentView)
        scrollView.showsHorizontalScrollIndicator = false

        contentView.addSubviews(
            personImageView,
            nameLabel,
            birthInfoLabel,
            department,
            relatedMoviesLabel,
            seeAllButton,
            relatedMoviesCollectionView
        )

        // Handlers
        setupHandlers()
    }

    private func setupHandlers() {
        relatedMoviesCollectionView.dataSource = relatedMoviesCollectionViewHandler
        relatedMoviesCollectionView.delegate = relatedMoviesCollectionViewHandler
    }

    func updateDelegates() {
        relatedMoviesCollectionViewHandler.delegate = delegate
    }
}

// MARK: - ActionMethods
extension PersonDetailsView {
    @objc
    private func didTapSeeAllButton() {
//        delegate?.didTapSeeAllButton()
    }
}

// MARK: - Constraints
extension PersonDetailsView {
    private func setupConstraints() {
        setupScrollConstraints()
        setupMainConstraints()
        setupOtherConstraints()
    }

    private func setupScrollConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    private func setupMainConstraints() {
        personImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.width.equalTo(UIScreen.main.bounds.width * 0.7 / 2)
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

        department.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(birthInfoLabel.snp.bottom).offset(8)
        }

        relatedMoviesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(personImageView.snp.bottom).offset(32)
        }

        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(relatedMoviesLabel)
        }

        relatedMoviesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(relatedMoviesLabel.snp.bottom).offset(8)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupOtherConstraints() {
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
