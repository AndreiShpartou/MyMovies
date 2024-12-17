//
//  TMDBPersonResponseProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 16/12/2024.
//

import Foundation

protocol TMDBPersonResponseProtocol: PagedResponseResultProtocol {
    var id: Int { get }
    var name: String { get }
    var original_name: String { get }
    var profile_path: String? { get }
    var known_for_department: String? { get }

    func personPhotoURL(path: String?, size: PersonSize) -> String?
}
