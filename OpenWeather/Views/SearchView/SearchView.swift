//
//  ContentView.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import SwiftUI
import MapKit

class SearchCompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

struct SearchView: View {
    @State private var searchText: String = ""
    @ObservedObject private var completerDelegate = SearchCompleterDelegate()
    private let completer = MKLocalSearchCompleter()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter City Name...", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        performSearch(query: newValue)
                    }
                
                List {
                    ForEach(getCityList(results: completerDelegate.searchResults)) { location in
                        NavigationLink(destination: DetailView(viewModel: DetailViewViewModel(location: location))) {
                            Text(locationText(location:location))
                        }
                    }
                }
            }
            .onAppear {
                completer.delegate = completerDelegate
            }
        }
    }

    private func performSearch(query: String) {
        completer.queryFragment = query
    }
    
    func getCityList(results: [MKLocalSearchCompletion]) -> [SimpleLocation] {
        
        // create each location item, use the set to eliminate duplicates
        var searchResults: Set<SimpleLocation> = []
        
        let filtered = results.filter { !$0.subtitle.contains("Search Nearby") }
        for result in filtered {
            
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            
            // creating a SimpleLocation from either MKLocalSearchCompletion format
            locationFromSearchCompletion(titleComponents, subtitleComponents) {place in
                if place.city != "" && place.country != "" {
                    searchResults.insert(place)
                }
            }
        }
        
        // sorting alphabetically by city, same city name will sort by state, with no state coming first
        let sorted = Array(searchResults).sorted { lhs, rhs in
            if lhs.city == rhs.city {
                return lhs.state ?? "" < rhs.state ?? ""
            }
            return lhs.city < rhs.city
        }
        return sorted
    }

    func locationFromSearchCompletion(_ title: [String],_ subtitle: [String], _ completion: @escaping (SimpleLocation) -> Void) {
        
        var city: String = ""
        var state: String?
        var country: String = ""
        
        if title.count > 1 && subtitle.count > 1 {
            
            city = title.first!
            state = title[1]
            country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
        } else {
            if title.count >= 1 && subtitle.count == 1 {
                
                city = title.first!
                if title.count > 1 {
                    state = title[1]
                }
                country = subtitle.last!
            }
        }
        
        completion(SimpleLocation(city: city, state: state, country: country))
    }

    func locationText(location: SimpleLocation) -> String {
        var text = "\(location.city)"
        if let state = location.state {
            text += ", \(state)"
        }
        text += ", \(location.country)"
        return text
    }
}

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
