//
//  OnboardingView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 20/02/2025.
//

import UIKit
import Lottie

final class OnboardingView: UIView, OnboardingViewProtocol {
    weak var delegate: OnboardingViewDelegate?

    // MARK: - Data
    private var pages: [OnboardingPageViewModelProtocol] = [] {
        didSet {
            preloadLottieAnimations()
        }
    }
    private var currentIndex: Int = 0

    // MARK: - UI Components
    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textAlignment: .center,
        textColor: .textColorWhite
    )
    private let descriptionLabel: UILabel = .createLabel(
        font: Typography.Medium.title,
        numberOfLines: 0,
        textAlignment: .center,
        textColor: .textColorWhiteGrey
    )
    private let animationView = LottieAnimationView()
    private let pageControl = UIPageControl()
    // Navigation buttons
    private lazy var skipButton = UIButton(
        title: "Skip",
        font: Typography.SemiBold.body,
        titleColor: .primaryBlueAccent,
        backgroundColor: .clear,
        cornerRadius: 0,
        action: #selector(didTapSkip),
        target: self
    )
    private lazy var nextButton = UIButton(
        title: "Next",
        font: Typography.SemiBold.body,
        titleColor: .textColorWhite,
        backgroundColor: .primaryBlueAccent,
        cornerRadius: 8,
        action: #selector(didTapNext),
        target: self
    )

    private lazy var getStartedButton = UIButton(
        title: "Get Started",
        font: Typography.SemiBold.body,
        titleColor: .textColorWhite,
        backgroundColor: .secondaryGreen,
        cornerRadius: 8,
        action: #selector(didTapGetStarted),
        target: self
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

    // MARK: - OnboardingViewProtocol
    func configurePages(_ pages: [OnboardingPageViewModelProtocol]) {
        self.pages = pages
        pageControl.numberOfPages = pages.count
        showPage(at: 0)
    }

    func showPage(at index: Int) {
        guard index < pages.count else { return }
        currentIndex = index
        let page = pages[index]

        // Update UI
        titleLabel.text = page.title
        descriptionLabel.text = page.description

        // Lottie animation
        if let lottieFileName = page.lottieFileName {
            let animation = LottieAnimation.named(lottieFileName)
            animationView.animation = animation
            animationView.loopMode = .loop
            animationView.play()
        } else {
            animationView.stop()
            animationView.animation = nil
        }

        pageControl.currentPage = index

        // Show / Hide Buttons
        let isLastPage = (index == pages.count - 1)
        nextButton.isHidden = isLastPage
        getStartedButton.isHidden = !isLastPage
    }

    func showError() {
        //
    }
}

// MARK: - SetupView
extension OnboardingView {
    private func setupView() {
        backgroundColor = .primaryBackground
        getStartedButton.isHidden = true
        pageControl.isUserInteractionEnabled = false

        addSubviews(
            titleLabel,
            descriptionLabel,
            animationView,
            pageControl,
            skipButton,
            nextButton,
            getStartedButton
        )
    }
    
    private func preloadLottieAnimations() {
        pages.forEach { page in
            if let lottieFileName = page.lottieFileName {
                _ = LottieAnimation.named(lottieFileName)
            }
        }
    }
}

// MARK: - Action Methods
extension OnboardingView {
    @objc
    private func didTapSkip() {
        delegate?.didTapSkip()
    }

    @objc
    private func didTapNext() {
        delegate?.didTapNext()
    }

    @objc
    private func didTapGetStarted() {
        delegate?.didTapGetStarted()
    }
}

// MARK: - Constraints
extension OnboardingView {
    private func setupConstraints() {
        skipButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(44)
        }

        animationView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(skipButton.snp.bottom)
            make.bottom.equalTo(self.snp.centerY).multipliedBy(1.2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(animationView.snp.bottom).offset(8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-32)
            make.height.equalTo(44)
        }

        getStartedButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}
