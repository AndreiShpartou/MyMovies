//
//  PersonCircleCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 16/11/2024.
//

import UIKit
import Kingfisher

final class PersonCircleCollectionViewCell: UICollectionViewCell {
    static let identifier = "PersonCollectionViewCell"

    // MARK: - UIComponents
    private let personImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 25
    )

    private let nameLabel: UILabel = .createLabel(
        font: Typography.Medium.title,
        textAlignment: .center,
        textColor: .textColorWhiteGrey
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

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        personImageView.kf.cancelDownloadTask()
        personImageView.image = nil
        nameLabel.text = nil
    }

    // MARK: - Public
    func configure(with person: PersonViewModelProtocol) {
        personImageView.kf.setImage(with: person.photo, placeholder: Asset.Avatars.avatarDefault.image)
        nameLabel.text = person.name
    }
}

// MARK: - Setup
extension PersonCircleCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(personImageView, nameLabel)
    }
}

// MARK: - Constraints
extension PersonCircleCollectionViewCell {
    private func setupConstraints() {
        personImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.width.equalTo(50)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(personImageView.snp.bottom).offset(4)
        }
    }
}
