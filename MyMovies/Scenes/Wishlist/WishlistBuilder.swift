//
//  WishlistBuilder.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol WishBuilderProtocol: AnyObject {
    static func build() -> UIViewController
}

final class WishlistBuilder: WishBuilderProtocol {
    static func build() -> UIViewController {
        return WishlistViewController()
    }
}
