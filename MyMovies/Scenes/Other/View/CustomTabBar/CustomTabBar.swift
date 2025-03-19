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

    private let containerView: UIView = .createCommonView(backgroundColor: .primaryBackground)
    private var itemWidthConstraints = [Int: Constraint]()

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
        addSubviews(containerView)
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
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        // Add new and set default constraints
        for (index, item) in customTabBarItems.enumerated() {
            containerView.addSubviews(item)
            let previousItem = customTabBarItems[safe: index - 1]
            let leadingConstraint = previousItem?.snp.trailing ?? containerView.snp.leading

            item.snp.makeConstraints { make in
                make.leading.equalTo(leadingConstraint)
                make.bottom.height.equalToSuperview()
                // save constraints to onward updating
                let widthConstraint = make.width.equalToSuperview().multipliedBy(0.1).constraint
                itemWidthConstraints[index] = widthConstraint
            }
            // Set default priority
            item.setContentHuggingPriority(UILayoutPriority(Float(index)), for: .horizontal)
        }
    }

    private func adjustTabBarItemsWidth(selectedIndex: Int) {
        let selectedItemMultiplier: Float = 0.4
        let unselectedItemMultiplier: Float = (1 - selectedItemMultiplier) / Float(customTabBarItems.count - 1)

        for (index, item) in customTabBarItems.enumerated() {
            let multiplier = (index == selectedIndex) ? selectedItemMultiplier : unselectedItemMultiplier
            let priority: UILayoutPriority = (index == selectedIndex) ? .defaultLow : .defaultHigh
            // Remove old constraint and apply new one
            itemWidthConstraints[index]?.deactivate()
            item.snp.makeConstraints { make in
                let newWidthConstraint = make.width.equalToSuperview().multipliedBy(multiplier)
                itemWidthConstraints[index] = newWidthConstraint.constraint
            }
            item.setContentHuggingPriority(priority, for: .horizontal)
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // Update layout
        }
    }
}

// MARK: - Constraints
extension CustomTabBar {
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
