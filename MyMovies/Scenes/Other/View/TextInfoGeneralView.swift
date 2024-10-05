//
//  TextInfoGeneralView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/10/2024.
//

import UIKit

protocol TextInfoGeneralViewProtocol: UIView {
    var delegate: TextInfoGeneralViewDelegate? { get set }

    func configure(with labelText: String?, and textViewText: String?, title: String)
}

protocol TextInfoGeneralViewDelegate: AnyObject {
    func didTapCloseButton()
}

final class TextInfoGeneralView: UIView, TextInfoGeneralViewProtocol {
    weak var delegate: TextInfoGeneralViewDelegate?

    // MARK: - UIComponents
    private let titleLabel: UILabel = .createLabel(
        font: Typography.SemiBold.largeTitle,
        textAlignment: .center,
        textColor: .textColorWhiteGrey
    )
    private lazy var closeButton: UIButton = createCloseButton()
    private let label: UILabel = .createLabel(
        font: Typography.SemiBold.title,
        textColor: .textColorWhiteGrey
    )
    private let textView: UITextView = .createCommonTextView(isScrollEnabled: true)

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
    func configure(with labelText: String?, and textViewText: String?, title: String) {
        titleLabel.text = title
        label.text = labelText
        if let text = textViewText,
           let attrubitedText = text.convertHtmlToAttributedString(
            font: Typography.Regular.title,
            textColor: .textColorWhiteGrey
           ) {
            textView.attributedText = attrubitedText
        } else {
            textView.text = textViewText
        }
    }
}

// MARK: - Setup
extension TextInfoGeneralView {
    private func setupView() {
        backgroundColor = .primaryBackground
        addSubviews(titleLabel, closeButton, label, textView)
    }
}

// MARK: - ActionMethods
extension TextInfoGeneralView {
    @objc
    private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}

// MARK: - Helpers
extension TextInfoGeneralView {
    private func createCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .primarySoft
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .primaryBlueAccent
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)

        return button
    }
}

// MARK: - Constraints
extension TextInfoGeneralView {
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
        }

        label.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.greaterThanOrEqualTo(20).priority(.low)
        }

        textView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(label.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(16)
        }
    }
}
