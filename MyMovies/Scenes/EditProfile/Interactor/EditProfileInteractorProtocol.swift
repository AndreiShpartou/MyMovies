//
//  EditProfileInteractorProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

protocol EditProfileInteractorProtocol {
    var presenter: EditProfileInteractorOutputProtocol? { get set }
}

protocol EditProfileInteractorOutputProtocol: AnyObject {
}
