//
//  OpenWeatherApp.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import SwiftUI

@main
struct OpenWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewViewModel())
        }
    }
}

/*
 Error return from the backend without the paid plan yet
Raw JSON: {"cod":401, "message": "Please note that using One Call 3.0 requires a separate subscription to the One Call by Call plan. Learn more here https://openweathermap.org/price. If you have a valid subscription to the One Call by Call plan, but still receive this error, then please see https://openweathermap.org/faq#error401 for more info."}
*/

/*
 Objective: Build a simple iOS weather app that fetches weather data from a public API and displays it to the user in a user-friendly interface.
 Requirements:
 * Use the OpenWeatherMap API (https://openweathermap.org/api) to fetch weather data.
 ✅︎ Support iOS 15 and up
 * The app should have at least two screens:
 * Screen 1: A screen where users can enter the name of a city to get the current weather information.
 * Screen 2: Display the retrieved weather information, including at least temperature, weather description, and an icon representing the weather condition.
 * Implement error handling for cases such as no internet connection or invalid city names.
 Provide a refresh mechanism to update the weather data.
 Use Swift and follow best practices for iOS development.
 Add comments where necessary to explain your code.
 
 Bonus Points (Optional):
 Implement a unit test for a critical part of your code.
 * Allow the user to switch between Celsius and Fahrenheit.
 * Use a design pattern like MVVM and Combine framework
 * Include loading indicators during API calls.
 */
