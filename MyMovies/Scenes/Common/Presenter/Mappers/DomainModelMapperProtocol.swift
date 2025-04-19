//
//  DomainModelMapperProtocol.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 18/09/2024.
//

import Foundation

protocol DomainModelMapperProtocol {
    func map<T, Y>(data: T, to returnType: Y.Type) -> Y?
}
