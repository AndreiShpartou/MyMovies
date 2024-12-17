//
//  KinopoiskPersonResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 17/12/2024.
//

import Foundation

protocol KinopoiskPersonResponseProtocol: PagedResponseResultProtocol {
    var id: Int? { get }
    var photo: String? { get }
    var name: String? { get }
    var enName: String? { get }
    var description: String? { get }
    var profession: String? { get }
    var enProfession: String? { get }
}
