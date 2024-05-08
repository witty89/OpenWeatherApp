//
//  SearchBar.swift
//  OpenWeather
//
//  Created by Alex Whitlock on 5/6/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
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
        .onTapGesture {
            isSearching = true
        }
    }
}
