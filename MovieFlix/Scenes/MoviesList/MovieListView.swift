//
//  MovieListView.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 9/3/24.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel = MovieListViewModel()
    @State var searchText: String = ""
    @State private var isLoadingMore = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(
                    searchText: $searchText,
                    performSearch: { searchText in
                        viewModel.searchMovies(searchText: searchText)
                    },
                    clearList: viewModel.clearList,
                    loadPopularMovies: viewModel.loadPopularMovies
                )
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(0..<viewModel.movies.count, id: \.self) { index in
                                let movie = viewModel.movies[index]
                                MovieRowView(
                                    movie: movie,
                                    releaseDate: viewModel.formattedReleaseDate(for: movie) ?? "",
                                    favoriteTapped: { movie in
                                        viewModel.toggleFavorite(for: movie)
                                    }
                                )
                                .onAppear {
                                    if index == viewModel.movies.count - 1 {
                                        viewModel.loadPopularMovies()
                                    }
                                }
                            }
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("MovieFlix")
        }
    }
}



#Preview {
    MovieListView()
}
