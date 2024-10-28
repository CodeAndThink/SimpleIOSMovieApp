//
//  DetailViewModel.swift
//  Movie
//
//  Created by admin on 24/10/24.
//
import Foundation

protocol FetchMovieDetailDataDeligate : AnyObject{
    func didFetchMovieDetail(to movie : MovieModel)
}

class DetailViewModel {
    weak var deligate : FetchMovieDetailDataDeligate?
    private var repository : Repository
    
    init() {
        self.repository = Repository.shared()
    }
    
    func fetchMovieDetail (movieId : Int) async {
        do {
            let movieDetail = try await repository.fetchDetailMovieData(movieId: movieId)
            DispatchQueue.main.async {
                self.deligate?.didFetchMovieDetail(to: movieDetail)
            }
        } catch {
            print(error)
        }
    }
}
