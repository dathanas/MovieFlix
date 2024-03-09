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
    var loadPopularMovies: () -> Void
    
    @State private var timer: Timer?

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: searchText) { newValue in
                    startTimer()
                }

            Button(action: {
                searchText = ""
                loadPopularMovies()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .opacity(searchText == "" ? 0 : 1)
            }
            .accentColor(.secondary)
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            performSearch(searchText)
        }
    }
}
