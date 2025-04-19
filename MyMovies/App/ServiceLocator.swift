//
//  ServiceLocator.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 10/04/2025.
//

import Foundation

protocol ServiceLocatorProtocol {
    func getService<T>() -> T?
}

final class ServiceLocator: ServiceLocatorProtocol {
    static let shared = ServiceLocator()

    private var services: [String: Any] = [:]

    private init() {}

    private func keyFor<T>(_ type: T.Type) -> String {
        return String(describing: type)
    }

    func addService<T>(service: T) {
        let key = keyFor(T.self)
        services[key] = service
    }

    func getService<T>() -> T? {
        let key = keyFor(T.self)
        return services[key] as? T
    }
}
