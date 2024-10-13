//
//  EditProfileInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/10/2024.
//

import Foundation

final class EditProfileInteractor: EditProfileInteractorProtocol {
    weak var presenter: EditProfileInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
}
