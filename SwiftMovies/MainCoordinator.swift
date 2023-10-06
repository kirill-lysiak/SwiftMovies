//
//  MainCoordinator.swift
//  SwiftMovies
//
//  Created by Kirill on 6.10.2023.
//

import Foundation
import Combine

class MainCoordinator: ObservableObject {
    private var cancellable: AnyCancellable?
    
    @Published var fetching = false
    
    @Published var moviesList: MoviesList? = nil
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchMovies()
        }
    }
    
    private func fetchMovies() {
        fetching = true
        
        cancellable = BaseAPI.fetchMovies().sink(
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
            receiveValue: { [weak self] moviesList in
                DispatchQueue.main.async {
                    self?.moviesList = moviesList
                }
            }
        )
    }
    
    func fetchTapped() {
        fetchMovies()
    }
    
    deinit {
        cancellable = nil
        moviesList = nil
    }
}

