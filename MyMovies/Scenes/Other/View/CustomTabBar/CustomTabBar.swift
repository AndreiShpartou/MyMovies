//
//  CustomTabBar.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 04/08/2024.
//

import UIKit
import SnapKit

final class CustomTabBar: UITabBar {
    var customTabBarItems = [CustomTabBarItem]()

    private let containerStackView: UIStackView = .createCommonStackView(
        axis: .horizontal,
        distribution: .fill,
        alignment: .fill
    )

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTabBar()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()

        // Disable default tabBar buttons to ensure the work of GestureRecognizers
        disableDefaultTabBarButtons()
    }

    // MARK: - Public
    func setCustomItems(_ items: [CustomTabBarItem]) {
        customTabBarItems = items
        rearrangeTabBarItems()
    }

    func selectItem(at index: Int) {
        for (itemIndex, item) in customTabBarItems.enumerated() {
            item.isSelected = (itemIndex == index)
        }

        adjustTabBarItemsWidth(selectedIndex: index)
    }
}

// MARK: - Private Setup
extension CustomTabBar {
    private func setupTabBar() {
        setupAppearance()
        addSubviews(containerStackView)
        // adjust container view
        containerStackView.isUserInteractionEnabled = true
    }

    private func setupAppearance() {
        backgroundColor = .primaryBackground
        isTranslucent = false
        barTintColor = .primaryBackground
    }
}

// MARK: - Update layout
extension CustomTabBar {
    // Disable default tabBar buttons
    private func disableDefaultTabBarButtons() {
        for subview in subviews where subview is UIControl && subview.isUserInteractionEnabled {
            subview.isUserInteractionEnabled = false
        }
    }

    // Rearrange tab bar items to force width change
    private func rearrangeTabBarItems() {
        // Clear old
        containerStackView.arrangedSubviews.forEach {
            containerStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Add new
        customTabBarItems.forEach { containerStackView.addArrangedSubview($0) }
    }

    private func adjustTabBarItemsWidth(selectedIndex: Int) {
        let selectedItemMultiplier: Float = 0.4
        let unselectedItemMultiplier: Float = (1 - selectedItemMultiplier) / Float(customTabBarItems.count - 1)

        for (index, item) in customTabBarItems.enumerated() {
            let multiplier = (index == selectedIndex) ? selectedItemMultiplier : unselectedItemMultiplier
            item.snp.remakeConstraints { make in
                make.width.equalToSuperview().multipliedBy(multiplier).priority(.high)
                make.leading.trailing.equalToSuperview().priority(.low)
                make.top.bottom.equalToSuperview().priority(.low)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // Update layout
        }
    }
}

// MARK: - Constraints
extension CustomTabBar {
    private func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
