//
//  KinopoiskPersonResponse.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/12/2024.
//

import Foundation

struct KinopoiskPersonResponse: KinopoiskPersonResponseProtocol {
    let id: Int?
    var photo: String?
    let name: String?
    var enName: String?
    var description: String?
    var profession: String?
    var enProfession: String?
}
