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
    var name: String?
    var enName: String?
    var birthday: String?
    var death: String?
    var birthPlace: [CommonValue]?
    var profession: [CommonValue]?
}
