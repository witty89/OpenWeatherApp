//
//  ContentViewViewModel.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/7/24.
//

import Foundation
import Combine
import MapKit

class SearchCompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

class SearchViewViewModel: ObservableObject {
    let completer = MKLocalSearchCompleter()

    func locationText(location: SimpleLocation) -> String {
        var text = "\(location.city)"
        if let state = location.state {
            text += ", \(state)"
        }
        text += ", \(location.country)"
        return text
    }
    
    func performSearch(query: String) {
        completer.queryFragment = query
    }
    
    func getCityList(results: [MKLocalSearchCompletion]) -> [SimpleLocation] {
        
        // create each location item, use the set to eliminate duplicates
        var searchResults: Set<SimpleLocation> = []
        
        let filtered = results.filter { !$0.subtitle.contains("Search Nearby") && !$0.subtitle.contains("No Results Nearby") }
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
}
