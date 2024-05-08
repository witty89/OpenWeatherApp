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
                Text("Search")
                    .font(.title)
                
                searchBar
                    .padding(.bottom, 12)
                
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

    var searchBar: some View {
        HStack {
            TextField("Enter City Here...", text: $searchText)
                .padding(.leading, 12)
                .padding(.vertical, 12)
            
            Button(action: {
                searchText = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .padding(.trailing, 12)
                    .opacity(searchText == "" ? 0 : 1)
            })
        }
        .padding(.horizontal)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal)
        .onChange(of: searchText) { newValue in
            viewModel.performSearch(query: newValue)
        }
    }
}
