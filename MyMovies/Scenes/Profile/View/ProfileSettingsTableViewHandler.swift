//
//  ProfileSettingsTableViewHandler.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 08/10/2024.
//

import UIKit

final class ProfileSettingsTableViewHandler: NSObject {
    weak var delegate: ProfileSettingsInteractionDelegate?

    private var sections: [ProfileSettingsSectionViewModelProtocol] = []

    // MARK: - Public
    func configure(with sections: [ProfileSettingsSectionViewModelProtocol]) {
        self.sections = sections
    }
}

// MARK: - UITableViewDataSource
extension ProfileSettingsTableViewHandler: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingsTableViewCell.identifier) as? ProfileSettingsTableViewCell else {
            fatalError("Failed to dequeue ProfileSettingsTableViewCell")
        }

        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileSettingsTableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfileSettingsTableViewCell else {
            return
        }

        cell.setSelectedCustrom(true, animated: true)
        delegate?.didSelectSetting(at: indexPath)
        cell.setSelectedCustrom(false, animated: true)
    }

    // Height for Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = sections[section].title
        let headerView: UIView = .createCommonView(backgroundColor: .primarySoft)
        let contentView: UIView = .createCommonView(backgroundColor: .primaryBackground)
        let label: UILabel = .createLabel(
            font: Typography.SemiBold.largeTitle,
            textColor: .textColorWhite,
            text: headerTitle
        )
        headerView.addSubviews(contentView)
        contentView.addSubviews(label)

        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(Constants.bottomBorderHeight)
            make.bottom.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(Constants.headerInset)
        }

        return headerView
    }

    // Footer Height to remove extra separators
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.footerHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ProfileSettingsTableViewCell else {
            return
        }

        if indexPath.row == sections[indexPath.section].items.count - 1 {
            cell.createBottomBorder()
        }
    }
}

// MARK: - Constants
extension ProfileSettingsTableViewHandler {
    private enum Constants {
        static let headerHeight: CGFloat = 40
        static let footerHeight: CGFloat = 0.01
        static let rowHeight: CGFloat = 80
        static let headerInset: CGFloat = 16
        static let bottomBorderHeight: CGFloat = 2
        static let bottomBorderInset: CGFloat = 16
    }
}
