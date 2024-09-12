//
//  NetworkHelperProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 19/08/2024.
//

import Foundation

protocol NetworkHelperProtocol {
    func getPublicIPAddress(completion: @escaping (Result<String, Error>) -> Void)
    func getCountry(for ip: String, completion: @escaping (Result<String, Error>) -> Void)
}
