//
//  Location.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import Foundation
struct Location: Decodable {
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
