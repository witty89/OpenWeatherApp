//
//  ContentView.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject var viewModel: SearchViewViewModel
    @State private var searchText: String = ""
    @ObservedObject private var completerDelegate = SearchCompleterDelegate()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter City Name...", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        viewModel.performSearch(query: newValue)
                    }
                
                List {
                    ForEach(viewModel.getCityList(results: completerDelegate.searchResults)) { location in
                        NavigationLink(destination: DetailView(viewModel: DetailViewViewModel(location: location))) {
                            Text(viewModel.locationText(location:location))
                        }
                    }
                }
            }
            .onAppear {
                viewModel.completer.delegate = completerDelegate
            }
        }
    }

}
