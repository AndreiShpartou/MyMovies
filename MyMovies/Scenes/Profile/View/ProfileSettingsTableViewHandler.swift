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
        let item = sections[indexPath.section].items[indexPath.row]
        delegate?.didSelectSettingsItem(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Height for Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = sections[section].title
        let headerView: UIView = .createCommonView(backgroundColor: .primaryBackground)
        let label: UILabel = .createLabel(
            font: Typography.SemiBold.subhead,
            textColor: .textColorGrey
        )
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        headerView.addSubviews(label)

        return headerView
    }

    // Footer Height to remove extra separators
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // Row Animation and Borders
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ProfileSettingsTableViewCell else {
            return
        }
//        cell.separatorView.isHidden = true // Hide default separators

//        // Add custom border if not the last row in the section
//        if indexPath.row < sections[indexPath.section].items.count - 1 {
//            cell.addBottomBorder(with: .separatorColor), heightL 0.5, inset: 16
//        }
    }
}
