//
//  MovieRowView.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 9/3/24.
//

import SwiftUI
import Kingfisher

struct MovieRowView: View {
    let movie: Movie
    let releaseDate: String
    var favoriteTapped: (Movie) -> Void
    
    var body: some View {
        ZStack {
            if let backdropPath = movie.backdropPath {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .clipped()
            }
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(movie.title)
                    .foregroundColor(.white)
                    .font(.headline)
                    
                
                HStack {
                    Text(releaseDate)
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(uiImage: movie.isFavorite ? UIImage(resource: .heartRed) : UIImage(resource: .heartGray))
                        .onTapGesture {
                            favoriteTapped(movie)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .padding(.all, 16)
    }
}



#Preview {
    MovieRowView(movie: Movie(id: 1, title: "The Avengers", backdropPath: "/4woSOUD0equAYzvwhWBHIJDCM88.jpg", releaseDate: "2024-01-18", voteAverage: 3.5), releaseDate: "18 Jan 2024", favoriteTapped: { movie in })
}
