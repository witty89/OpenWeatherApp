//
//  DetailViewViewModel.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import Foundation
import SwiftUI
import Combine

class DetailViewViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var error: String?
    @Published var isShowingError = false
    @Published var isFahrenheit = true
    
    var location: SimpleLocation
    var weatherAttributes: [WeatherAttribute] = []
    var temperatureUnit: String {
        return isFahrenheit ? "°F" : "°C"
    }
    
    var weatherData: WeatherData? // TODO: - privatize
    private var cancellables = Set<AnyCancellable>()
    
    init(location: SimpleLocation) {
        self.location = location
        $isFahrenheit.sink { value in
            self.createWeatherAttributes(isFahrenheit: value)
        }.store(in: &cancellables)
        getData()
    }
    
    func getData() {
        Networking.shared.fetchLatLon(city: location.city, state: location.state ?? "", country: location.country)
            .flatMap { (lat, lon) in
                Networking.shared.fetchWeather(lat: lat, lon: lon, exclude: "")
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // Handle error if needed
                    print("Error: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }, receiveValue: { weatherData in
                self.weatherData = weatherData
                self.isLoading = false
                self.createWeatherAttributes(isFahrenheit: self.isFahrenheit)
            })
            .store(in: &Networking.shared.cancellables)
    }
        
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 2
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    struct WeatherAttribute: Identifiable {
        let id = UUID()
        var title: String
        var value: String
    }
    
    func createWeatherAttributes(isFahrenheit: Bool) {
        guard let weatherData = weatherData else { return }
        weatherAttributes = []
        let current = weatherData.current
        // temp
        let tempAttribute = WeatherAttribute(title: "Temperature", value: convertTemp(temp: current.temp, from: .kelvin, to: isFahrenheit ? .fahrenheit : .celsius))
        weatherAttributes.append(tempAttribute)
        
        // feels like
        let feelsLikeAttribute = WeatherAttribute(title: "Feels Like", value: convertTemp(temp: current.feelsLike, from: .kelvin, to: isFahrenheit ? .fahrenheit : .celsius))
        weatherAttributes.append(feelsLikeAttribute)
        
        // humidity
        let humidityAttribute = WeatherAttribute(title: "Humidity", value: "\(current.humidity.description)%")
        weatherAttributes.append(humidityAttribute)
        
        // wind
        let windAttribute = WeatherAttribute(title: "Wind", value: "\(current.windSpeed.description) m/s")
        weatherAttributes.append(windAttribute)

        // pressure
        let pressureAttribute = WeatherAttribute(title: "Pressure", value: "\(current.pressure.description) hPa")
        weatherAttributes.append(pressureAttribute)
    }
}

