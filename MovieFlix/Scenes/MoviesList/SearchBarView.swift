//
//  SearchBarView.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 9/3/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var performSearch: (String) -> Void
    var clearList: () -> Void
    var loadPopularMovies: () -> Void
    
    @State private var timer: Timer?

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: searchText) { newValue in
                    // Clear list and start timer for performing search
                    clearList()
                    startTimer()
                }

            Button(action: {
                searchText = ""
                clearList()
                loadPopularMovies()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .opacity(searchText == "" ? 0 : 1)
            }
            .accentColor(.secondary)
        }
    }
    
    private func startTimer() {
        // Invalidate the existing timer
        timer?.invalidate()
        
        // Create a new timer with a 0.5 second delay
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            // Perform search action after the delay
            performSearch(searchText)
        }
    }
}
