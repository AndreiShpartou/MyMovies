//
//  UserGreetingViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 31/08/2024.
//

import UIKit

protocol UserGreetingViewProtocol: UIView {
    var delegate: UserGreetingViewDelegate? { get set }

    func configure(with username: String, avatarImage: UIImage?)
}

protocol UserGreetingViewDelegate: AnyObject {
    func didTapFavouriteButton()
}
