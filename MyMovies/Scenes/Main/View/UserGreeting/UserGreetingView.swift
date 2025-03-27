//
//  UserGreetingView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 31/08/2024.
//

import UIKit

final class UserGreetingView: UIView, UserGreetingViewProtocol {
    weak var delegate: UserGreetingViewDelegate?

    private let avatarImageView: UIImageView = .createImageView(
        contentMode: .scaleAspectFill,
        clipsToBounds: true,
        cornerRadius: 20,
        image: Asset.Avatars.avatarDefault.image
    )
    private let helloLabel: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhite,
        text: "Hello, Guest!"
    )
    private let favouriteButton: UIButton = .createFavouriteButton(isSelected: true)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(with username: String, avatarImage: UIImage?) {
        helloLabel.text = "Hello, \(username)"
        avatarImageView.image = avatarImage ?? Asset.Avatars.avatarDefault.image
    }
}

// MARK: - Setup
extension UserGreetingView {
    private func setupView() {
        backgroundColor = .clear

        addSubviews(avatarImageView, helloLabel, favouriteButton)

        favouriteButton.addTarget(self, action: #selector(didTapFavouriteButton), for: .touchUpInside)
    }
}

// MARK: - ActionMethods
extension UserGreetingView {
    @objc
    private func didTapFavouriteButton() {
        delegate?.didTapFavouriteButton()
    }
}

// MARK: - Constraints
extension UserGreetingView {
    private func setupConstraints() {

        avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(40)
        }

        helloLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(favouriteButton.snp.leading).offset(-16)
            make.centerY.equalTo(avatarImageView)
        }

        favouriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(32)
            make.centerY.equalTo(avatarImageView)
        }
    }
}
