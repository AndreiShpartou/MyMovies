//
//  PersonDetailsInteractor.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 11/02/2025.
//

import Foundation

final class PersonDetailsInteractor: PersonDetailsInteractorProtocol {
    weak var presenter: PersonDetailsInteractorOutputProtocol?

    private let networkManager: NetworkManagerProtocol
    private let personID: Int

    // MARK: - Init
    init(personID: Int, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
        self.personID = personID
    }

    // MARK: - Public
    func fetchPersonDetails() {
    }
}
