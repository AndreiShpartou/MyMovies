//
//  PersonDetailsView.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import UIKit
import SnapKit

final class PersonDetailsView: UIView, PersonDetailsViewProtocol {
    var delegate: PersonDetailsViewDelegate?

    func showPersonDetails(_ person: PersonDetailsViewModelProtocol) {
        //
    }

    func showPersonMovies(_ movies: [BriefMovieListItemViewModelProtocol]) {
        //
    }

    func showLoadingIndicator() {
        //
    }

    func hideLoadingIndicator() {
        //
    }

    func showError(error: Error) {
        //
    }
}
