//
//  GlobalFunctions.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 15/08/2024.
//

import UIKit

// MARK: - Print
func debugPrint(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("😎[\(fileName):\(line)] \(function) - \(message)")
    #endif
}

// MARK: - Dates
// Function to get the nearest Wednesday (for popular movies endpoint)
func getNearestWednesday(from date: Date) -> Date? {
    let calendar = Calendar.current
    let currentWeekday = calendar.component(.weekday, from: date)
    // Calculate the difference between the current day and Wednesday (4)
    // Weekday index: 1 - Sunday, .....
    let daysToAdd = (Calendar.current.firstWeekday + 3 - currentWeekday + 7) % 7
    // Add the number of days to reach the nearest Wednesday
    let nearestWednesday = calendar.date(byAdding: .day, value: daysToAdd, to: date)

    return nearestWednesday
}

// Function to format Date to "YYYY-MM-dd" format
func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    return dateFormatter.string(from: date)
}

func extractYear(from dateString: String?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"

    guard let dateString = dateString,
          let date = dateFormatter.date(from: dateString) else {
        return dateFormatter.string(from: Date())
    }

    return dateFormatter.string(from: date)
}

// MARK: - TextFormatting
func getNavigationBarTitleAttributes() -> [NSAttributedString.Key: Any]? {
    return [
        NSAttributedString.Key.font: Typography.SemiBold.title,
        NSAttributedString.Key.foregroundColor: UIColor.textColorWhite
    ]
}

// MARK: - Alerts
func getGlobalAlertController(for message: String) -> UIAlertController {
    let alert = UIAlertController(
        title: NSLocalizedString("Error", comment: "Error alert title"),
        message: message,
        preferredStyle: .alert
    )
    let action = UIAlertAction(
        title: NSLocalizedString("OK", comment: "OK button title"),
        style: .default
    )
    alert.addAction(action)

    return alert
}
