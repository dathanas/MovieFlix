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
    let movieRating: Int
    var favoriteTapped: (Movie) -> Void
    
    var body: some View {
        ZStack {
            if let backdropPath = movie.backdropPath, !backdropPath.isEmpty {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .clipped()
            } else {
                Color.gray
                    .frame(height: 200)
                    .cornerRadius(10)
                
                Text("No image available")
            }
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(movie.title)
                    .foregroundColor(.white)
                    .font(.headline)
                
                HStack {
                    ForEach(0..<5) { index in
                        if index < movieRating {
                            Image(uiImage: UIImage(resource: .star))
                        } else {
                            Image(uiImage: UIImage(resource: .starEmpty))
                        }
                    }
                    
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
