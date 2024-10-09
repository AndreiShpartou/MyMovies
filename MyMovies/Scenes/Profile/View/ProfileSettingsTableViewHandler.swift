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
        return Constants.headerHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = sections[section].title
        let headerView: UIView = .createCommonView(backgroundColor: .primaryBackground)
        let label: UILabel = .createLabel(
            font: Typography.SemiBold.subhead,
            textColor: .textColorWhite,
            text: headerTitle
        )
        headerView.addSubviews(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.headerInset)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let cornerRadius: CGFloat = 10.0
        let lineWidth: CGFloat = 2

        // deduct the line width to keep the line stay side the view
        let point1 = CGPoint(x: 0.0 + lineWidth / 2, y: view.frame.height)
        let point2 = CGPoint(x: 0.0 + lineWidth / 2, y: 0.0 + cornerRadius + lineWidth / 2)
        let point3 = CGPoint(x: 0.0 + cornerRadius + lineWidth / 2, y: 0.0 + lineWidth / 2)
        let point4 = CGPoint(x: view.frame.width - cornerRadius - lineWidth / 2, y: 0.0 + lineWidth / 2)
        let point5 = CGPoint(x: view.frame.width - lineWidth / 2, y: 0.0 + cornerRadius + lineWidth / 2)
        let point6 = CGPoint(x: view.frame.width - lineWidth / 2, y: view.frame.height - lineWidth / 2)

        // draw the whole line with upper corner radius
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addArc(
            withCenter: CGPoint(x: point3.x, y: point2.y),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: -.pi / 2,
            clockwise: true
        )
        path.addLine(to: point4)
        path.addArc(
            withCenter: CGPoint(x: point4.x, y: point5.y),
            radius: cornerRadius,
            startAngle: -.pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: point6)
        path.addLine(to: point1)

        let topBorder = CAShapeLayer()
        topBorder.path = path.cgPath
        topBorder.lineWidth = lineWidth
        topBorder.strokeColor = UIColor.purple.cgColor
        topBorder.fillColor = nil

        // add the line to header view
        view.layer.addSublayer(topBorder)
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
            cell.separatorView.isHidden = true
        }
    }
}

// MARK: - Constants
extension ProfileSettingsTableViewHandler {
    private enum Constants {
        static let headerHeight: CGFloat = 50.0
        static let footerHeight: CGFloat = 0.01
        static let rowHeight: CGFloat = 60.0
        static let headerInset: CGFloat = 16.0
        static let bottomBorderHeight: CGFloat = 2
        static let bottomBorderInset: CGFloat = 16.0
    }
}
