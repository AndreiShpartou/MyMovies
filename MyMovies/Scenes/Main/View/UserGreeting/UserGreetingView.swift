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
    private let loadingIndicator: UIActivityIndicatorView = .createSpinner(style: .large)

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
    func configure(_ profile: UserProfileViewModelProtocol) {
        helloLabel.text = "Hello, \(profile.name ?? "")"
        avatarImageView.kf.setImage(with: profile.profileImageURL, placeholder: Asset.Avatars.signedUser.image)
    }

    func didLogOut() {
        showLoggedOutState()
    }

    func showloadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}

// MARK: - Setup
extension UserGreetingView {
    private func setupView() {
        backgroundColor = .clear

        addSubviews(avatarImageView, helloLabel, favouriteButton, loadingIndicator)

        favouriteButton.addTarget(self, action: #selector(didTapFavouriteButton), for: .touchUpInside)
    }

    private func showLoggedOutState() {
        helloLabel.text = "Hello, Guest!"
        avatarImageView.image = Asset.Avatars.avatarDefault.image
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

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
