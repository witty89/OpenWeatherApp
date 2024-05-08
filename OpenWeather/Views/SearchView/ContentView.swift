//
//  ContentView.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                if viewModel.didTapSearch {
                    NavigationLink(destination: DetailView(viewModel: DetailViewViewModel(city: searchText))) {
                        searchTextView
                    }
                } else {
                    searchTextView
                }
            }
            .navigationTitle("Enter City")
        }
    }
    
    var searchTextView: some View {
        Text("Search")
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(.blue)
            .padding(.vertical, 12)
            .onTapGesture {
                viewModel.didTapSearch = true
            }
    }
}
