//
//  MovieDetailsCoordinator.swift
//  SwiftMovies
//
//  Created by Kirill on 6.10.2023.
//

import Foundation
import Combine

class MovieDetailsCoordinator: ObservableObject {
    private var cancellable: AnyCancellable?
    
    let movieId: Int
    
    @Published var fetching = false
    
    @Published var movie: Movie? = nil
    
    init(movieId: Int) {
        self.movieId = movieId
        
        fetchMovieDetails()
    }
    
    private func fetchMovieDetails() {
        fetching = true
        
        cancellable = BaseAPI.fetchMovieDetails(with: movieId).sink(
            receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let err):
                    print("--- fetch Error: \(err)")
                case .finished:
                    print("--- fetch completed")
                }
                
                DispatchQueue.main.async {
                    self?.fetching = false
                }
            },
            receiveValue: { [weak self] movie in
                DispatchQueue.main.async {
                    self?.movie = movie
                }
            }
        )
    }
    
    func fetchTapped() {
        fetchMovieDetails()
    }
    
    deinit {
        cancellable = nil
        movie = nil
    }
}

