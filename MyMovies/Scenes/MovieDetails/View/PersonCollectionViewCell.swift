//
//  PersonCollectionViewCell.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/09/2024.
//
import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
    static let identifier = "PersonCollectionViewCell"

    // MARK: - UIComponents
    private let imageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 8
    )

    private let nameLabel: UILabel = .createLabel(
        font: Typography.Regular.subhead,
        textColor: .textColorWhiteGrey
    )

    private let professionLabel: UILabel = .createLabel(
        font: Typography.Regular.body,
        textColor: .textColorDarkGrey
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

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        nameLabel.text = nil
        professionLabel.text = nil
    }

    // MARK: - Public
    func configure(with person: PersonViewModelProtocol) {
        imageView.kf.setImage(with: person.photo, placeholder: Asset.DefaultCovers.defaultPerson.image)
        nameLabel.text = person.name
        professionLabel.text = person.profession
    }
}

// MARK: - Setup
extension PersonCollectionViewCell {
    private func setupView() {
        contentView.addSubviews(imageView, nameLabel, professionLabel)
    }
}

// MARK: - Constraints
extension PersonCollectionViewCell {
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(150)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalTo(imageView).offset(8)
        }

        professionLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalTo(professionLabel).offset(8)
        }
    }
}
