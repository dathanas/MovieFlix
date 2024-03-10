//
//  MovieDetailsView.swift
//  MovieFlix
//
//  Created by Athanasleri, Despoina on 10/3/24.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 16) {
                    MovieBackdropView(viewModel: viewModel)
                    MovieDetailsContentView(viewModel: viewModel)
                        .padding(.horizontal, 24)
                }
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
            }
        }
    }
}

struct MovieBackdropView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    @State private var isShowingShareSheet = false
    
    var body: some View {
        ZStack {
            if let backdropPath = viewModel.movie.backdropPath, !backdropPath.isEmpty {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
            } else {
                Color.gray
                    .frame(height: 200)
                Text("No image available")
            }
            
            if let url = viewModel.movie.homepage, !url.isEmpty {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image(uiImage: UIImage(resource: .share))
                            .onTapGesture {
                                isShowingShareSheet = true
                            }
                            .sheet(isPresented: $isShowingShareSheet) {
                                ActivityViewController(activityItems: [url])
                            }
                    }
                }
            }
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIActivityViewController
    
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        //
    }
}

struct MovieDetailsContentView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.movie.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(viewModel.formattedGenres)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 24)
                Spacer()
                Image(uiImage: viewModel.movie.isFavorite ? UIImage(resource: .heartRed) : UIImage(resource: .heartGray))
                    .onTapGesture {
                        viewModel.favoriteTapped()
                    }
            }
            .padding(.bottom, 8)
            
            Text(viewModel.formattedReleaseDate() ?? "")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            HStack {
                ForEach(0..<5) { index in
                    Image(uiImage: UIImage(resource: index < viewModel.scaledRating() ? .star : .starEmpty))
                }
            }
            .padding(.bottom, 8)
            
            Text("Runtime")
                .font(.caption)
                .fontWeight(.bold)
            Text("\(viewModel.movie.runtime ?? 0) mins")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.bottom, 8)
            
            if let description = viewModel.movie.overview {
                Text("Description")
                    .font(.caption)
                    .fontWeight(.bold)
                Text(description)
                    .font(.caption)
                    .padding(.bottom, 8)
            }
            
            Text("Cast")
                .font(.caption)
                .fontWeight(.bold)
            Text(viewModel.formattedActors())
                .font(.caption)
            
            if let reviews = viewModel.movie.reviews?.results, !reviews.isEmpty {
                ReviewsView(reviews: reviews)
            }
        }
    }
}

struct ReviewsView: View {
    let reviews: [Review]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reviews")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.vertical, 8)
            ForEach(0..<2) { index in
                ReviewCell(review: reviews[index])
            }
        }
    }
}

struct ReviewCell: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.author ?? "Unknown")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Text(review.content ?? "")
                .font(.caption)
        }
        .padding(.bottom, 8)
    }
}
