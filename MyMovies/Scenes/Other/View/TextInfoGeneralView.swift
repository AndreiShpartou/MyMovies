//
//  TextInfoGeneralView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 03/10/2024.
//

import UIKit

protocol TextInfoGeneralViewProtocol: UIView {
    func configure(with labelText: String?, and textViewText: String?)
}

final class TextInfoGeneralView: UIView, TextInfoGeneralViewProtocol {
    // MARK: - UIComponents
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
    func configure(with labelText: String?, and textViewText: String?) {
        label.text = labelText
        textView.text = textViewText
    }
}

// MARK: - Setup
extension TextInfoGeneralView {
    private func setupView() {
        backgroundColor = .primaryBackground
        addSubviews(label, textView)
    }
}

// MARK: - Constraints
extension TextInfoGeneralView {
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.height.greaterThanOrEqualTo(20).priority(.low)
        }

        textView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(label.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(16)
        }
    }
}
