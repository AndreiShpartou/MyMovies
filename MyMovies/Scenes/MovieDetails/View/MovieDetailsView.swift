//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

final class MovieDetailsView: UIView, MovieDetailsViewProtocol {
    var presenter: MovieDetailsPresenterProtocol?

    // MARK: - UIComponents
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var backdropImageView: UIImageView = createBackdropImageView()

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
    }
}

// MARK: - Setup
extension MovieDetailsView {
    private func setupView() {
        backgroundColor = .primaryBackground

        addSubviews(scrollView, backdropImageView)
        scrollView.addSubviews(contentView)
        scrollView.showsVerticalScrollIndicator = false
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
    }
}
