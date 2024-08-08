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

    private let containerView = UIView()
    private let selectionBackgroundView: UIView = .createCommonView(
        cornderRadius: 12,
        backgroundColor: .primarySoft.withAlphaComponent(0.5)
    )

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContainerView()
        setupSelectionBackgroundView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()

        layoutCustomItems()
        disableDefaultTabBarButtons()
    }

    // MARK: - Public
    func setCustomItems(_ items: [CustomTabBarItem]) {
        customTabBarItems.forEach {
            $0.removeFromSuperview()
        }
        customTabBarItems = items
        customTabBarItems.forEach {
            containerView.addSubviews($0)
        }
    }

    func selectItem(at index: Int) {
        customTabBarItems.enumerated().forEach {
            $0.element.isSelected = ($0.offset == index)
        }
        updateSelectionBackgroundPosition()
    }

    // MARK: - Setup
    private func setupContainerView() {
        addSubviews(containerView)
    }

    private func setupSelectionBackgroundView() {
        containerView.insertSubview(selectionBackgroundView, at: 0)
    }

    private func layoutCustomItems() {
        // Remove old constraints before adding new ones
        customTabBarItems.forEach { $0.removeFromSuperview() }

        // Add items as subviews again to ensure they are visible
        customTabBarItems.forEach { containerView.addSubviews($0) }

        // Define constraints for each custom tab bar item
        let itemWidth = bounds.width / CGFloat(customTabBarItems.count) - 8
        let widthMultiplier = 1.0 / CGFloat(customTabBarItems.count)
        for (index, item) in customTabBarItems.enumerated() {
            item.snp.makeConstraints { make in
                make.leading.equalTo(containerView).offset(CGFloat(index) * itemWidth)
                make.top.bottom.equalTo(containerView)
                make.width.equalTo(containerView).multipliedBy(widthMultiplier)
            }
        }
        updateSelectionBackgroundPosition()
    }

    private func disableDefaultTabBarButtons() {
        for subview in subviews where subview is UIControl && subview.isUserInteractionEnabled {
            subview.isUserInteractionEnabled = false
        }
    }

    private func updateSelectionBackgroundPosition() {
        guard let selectedIndex = customTabBarItems.firstIndex(
            where: {
                $0.isSelected
            }
        ) else {
            return
        }

        let itemWidth = bounds.width / CGFloat(customTabBarItems.count)
        let width = itemWidth - 16
        let height = bounds.height / 1.5
        let xPosition = customTabBarItems[selectedIndex].frame.midX - itemWidth / 2
        let yPosition = customTabBarItems[selectedIndex].bounds.midY - height / 2

        selectionBackgroundView.frame = CGRect(x: xPosition + 8, y: yPosition, width: width, height: height)
    }
}

// MARK: - Constraints
extension CustomTabBar {
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
