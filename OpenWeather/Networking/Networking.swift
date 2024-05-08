//
//  Networking.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import Foundation
import Combine

class Networking {
    static let shared = Networking()
    var cancellables = Set<AnyCancellable>()
    private let apiKey = "2fdc6ae8f4df6f8416eded967fa3e59a"
    
    // required for the weather request, which needs the latitude and logitude
    func fetchLatLon(city: String, state: String, country: String) -> AnyPublisher<(Double, Double), Error> {
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(city),\(state),\(country)&limit=&appid=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return get(url)
            .flatMap { (model: [Location]) -> AnyPublisher<(Double, Double), Error> in
                guard let lat = model.first?.lat, let lon = model.first?.lon else {
                    return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                }
                return Just((lat, lon)).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // fetch the weather, passing in the lat lon that we got in the previous request
    func fetchWeather(lat: Double, lon: Double, exclude: String) -> AnyPublisher<WeatherData, Error> {
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude={part}&appid=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return get(url)
            .eraseToAnyPublisher()
    }
    
    // main networking get request
    func get<T: Decodable>(_ url: URL)  -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .map { data -> Data in
                        if let jsonStr = String(data: data, encoding: .utf8) {
                            print("Raw JSON: \(jsonStr)")
                        }
                        return data
                    }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
