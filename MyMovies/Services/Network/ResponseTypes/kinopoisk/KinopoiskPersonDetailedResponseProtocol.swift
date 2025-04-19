//
//  KinopoiskPersonDetailedResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 12/02/2025.
//

import Foundation

protocol KinopoiskPersonDetailedResponseProtocol: Codable {
    var id: Int { get }
    var photo: String? { get }
    var name: String? { get }
    var enName: String? { get }
    var birthday: String? { get }
    var death: String? { get }
    var birthPlace: [CommonValueProtocol]? { get }
    var profession: [CommonValueProtocol]? { get }
}
