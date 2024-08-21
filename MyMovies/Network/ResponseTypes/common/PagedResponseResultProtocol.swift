//
//  PagedResponseResultProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 21/08/2024.
//

import Foundation

protocol PagedResponseResultProtocol: Codable {
    var id: Int { get }
}
