//
//  Constants.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 30/07/2024.
//

import UIKit

// enum Constants {
//    static let defaultItemsInSection = 0
// }

// MARK: - Font
enum Typography {
    enum Regular {
        static let largeTitle = UIFont.montserratRegular(size: FontSize.largeTitle)
        static let title = UIFont.montserratRegular(size: FontSize.title)
        static let subhead = UIFont.montserratRegular(size: FontSize.subhead)
        static let body = UIFont.montserratRegular(size: FontSize.body)
        static let caption = UIFont.montserratRegular(size: FontSize.caption)
    }

    enum Medium {
        static let largeTitle = UIFont.montserratMedium(size: FontSize.largeTitle)
        static let title = UIFont.montserratMedium(size: FontSize.title)
        static let subhead = UIFont.montserratMedium(size: FontSize.subhead)
        static let body = UIFont.montserratMedium(size: FontSize.body)
        static let caption = UIFont.montserratMedium(size: FontSize.caption)
    }

    enum SemiBold {
        static let largeTitle = UIFont.montserratSemiBold(size: FontSize.largeTitle)
        static let title = UIFont.montserratSemiBold(size: FontSize.title)
        static let subhead = UIFont.montserratSemiBold(size: FontSize.subhead)
        static let body = UIFont.montserratSemiBold(size: FontSize.body)
        static let caption = UIFont.montserratSemiBold(size: FontSize.caption)
    }
}

enum FontName {
    static let regular = "Montserrat-Regular"
    static let medium = "Montserrat-Medium"
    static let semiBold = "Montserrat-SemiBold"
}

enum FontSize {
    static let largeTitle: CGFloat = 18
    static let title: CGFloat = 16
    static let subhead: CGFloat = 14
    static let body: CGFloat = 12
    static let caption: CGFloat = 10
}

enum DefaultValue {
    static let genre: GenreProtocol = Genre(id: nil, name: "all")
}

enum NotificationKeys {
    static let movieID = "MovieID"
    static let isFavourite = "IsFavourite"
}

enum Sizes {
    enum XSmall {
        static let padding: CGFloat = 4
        static let width: CGFloat = 40
        static let height: CGFloat = 35
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 0.5
        static let multiplayer: CGFloat = 0.15
    }

    enum Small {
        static let padding: CGFloat = 8
        static let width: CGFloat = 50
        static let height: CGFloat = 45
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let multiplayer: CGFloat = 0.25
    }

    enum Medium {
        static let padding: CGFloat = 16
        static let width: CGFloat = 100
        static let height: CGFloat = 70
        static let cornerRadius: CGFloat = 20
        static let borderWidth: CGFloat = 3
        static let multiplayer: CGFloat = 0.5
    }

    enum Large {
        static let padding: CGFloat = 32
        static let width: CGFloat = 200
        static let height: CGFloat = 180
        static let cornerRadius: CGFloat = 30
        static let borderWidth: CGFloat = 5
        static let multiplayer: CGFloat = 0.75
    }

    enum XLarge {
        static let padding: CGFloat = 64
        static let width: CGFloat = 400
        static let height: CGFloat = 300
        static let cornerRadius: CGFloat = 40
        static let borderWidth: CGFloat = 6
        static let multiplayer: CGFloat = 0.9
    }
}
