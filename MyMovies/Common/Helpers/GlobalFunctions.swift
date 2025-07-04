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

// Function to parse date from string (Uses for the birthdate and death date of a person)
func unifiedDateString(from input: String?) -> String? {
    // Return nil if input is nil or empty
    guard let input = input, !input.isEmpty else { return nil }

    // Define the possible input date formats.
    let inputFormats = [
        "yyyy-MM-dd",                    // TMDB format
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ"       // Kinopoisk format
    ]

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    var parsedDate: Date?
    // Try to parse the input using each format.
    for format in inputFormats {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: input) {
            parsedDate = date
            break
        }
    }

    // If parsing fails, return nil.
    guard let date = parsedDate else { return nil }

    // Set the output format you desire.
    dateFormatter.dateFormat = "MMMM d, yyyy"
    return dateFormatter.string(from: date)
}

func extractYear(from dateString: String?) -> String {
    guard let dateString = dateString else {
        return "N/A"
    }

    let dateFormatter = DateFormatter()

    // Try "yyyy-MM-dd"
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    // If that fails, try "yyyy"
    dateFormatter.dateFormat = "yyyy"
    if let date = dateFormatter.date(from: dateString) {
        return dateFormatter.string(from: date)
    }

    return "N/A"
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
        title: NSLocalizedString("Error", comment: ""),
        message: message,
        preferredStyle: .alert
    )
    let action = UIAlertAction(
        title: NSLocalizedString("OK", comment: ""),
        style: .default
    )
    alert.addAction(action)

    return alert
}

// MARK: - ImageView depiction
func applyBlurEffect(to imageView: UIImageView) {
    imageView.layoutIfNeeded()

    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = imageView.bounds
    blurEffectView.alpha = 0.5

    imageView.addSubview(blurEffectView)
}

func removeBlurEffect(from imageView: UIImageView) {
    imageView.subviews.forEach {
        guard $0 is UIVisualEffectView else { return }
        $0.removeFromSuperview()
    }
}
