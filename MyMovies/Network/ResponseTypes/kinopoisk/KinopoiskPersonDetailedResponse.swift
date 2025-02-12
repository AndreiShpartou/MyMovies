//
//  KinopoiskPersonDetailedResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/02/2025.
//

import Foundation

struct KinopoiskPersonDetailedResponse: KinopoiskPersonDetailedResponseProtocol {
    var id: Int
    var photo: String?
    var name: String
    var birthday: String?
    var death: String?
    var birthPlace: [CommonValueProtocol]? {
        return birthPlaces
    }
    var profession: [CommonValueProtocol]? {
        return professions
    }

    private let birthPlaces: [CommonValue]?
    private let professions: [CommonValue]?

    enum CodingKeys: String, CodingKey {
        case id
        case photo
        case name
        case birthday
        case death
        case birthPlaces = "birthPlace"
        case professions = "profession"
    }
}
