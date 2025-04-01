//
//  UserGreetingViewProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 31/08/2024.
//

import UIKit

protocol UserGreetingViewProtocol: UIView {
    var delegate: UserGreetingViewDelegate? { get set }

    func configure(_ profile: UserProfileViewModelProtocol)
    func didLogOut()
    func showloadingIndicator()
    func hideLoadingIndicator()
}

protocol UserGreetingViewDelegate: AnyObject {
    func didTapFavouriteButton()
}
