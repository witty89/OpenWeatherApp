//
//  SimpleLocation.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/7/24.
//

import Foundation
struct SimpleLocation: Hashable, Identifiable {
    let id = UUID()
    let city: String
    let state: String?
    let country: String

    // Implement the hash(into:) method
    func hash(into hasher: inout Hasher) {
        hasher.combine(city)
        hasher.combine(state)
        hasher.combine(country)
    }

    // Implement the == method to compare two instances for equality
    static func ==(lhs: SimpleLocation, rhs: SimpleLocation) -> Bool {
        return lhs.city == rhs.city && lhs.state == rhs.state && lhs.country == rhs.country
    }
}
