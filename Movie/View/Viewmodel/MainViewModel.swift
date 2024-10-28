//
//  MainViewModel.swift
//  Movie
//
//  Created by admin on 22/10/24.
//

import Foundation

protocol FetchMovieViewModelDelegate : AnyObject {
    func didFetchPopularMovieData (to datas : [MovieModel])
}

class MainViewModel {
    weak var delegate : FetchMovieViewModelDelegate?
    let repository : Repository
    
    private static var sharedMainViewModel : MainViewModel = {
        let viewModel = MainViewModel()
        return viewModel
    }()
    
    private init() {
        self.repository = Repository.shared()
    }
    
    class func shared() -> MainViewModel {
        return sharedMainViewModel
    }
    
    func fetchPopularMovieData (page : Int) async {
        do {
            let movieList = try await repository.fetchPopularMovieData(page: page)
            DispatchQueue.main.async {
                self.delegate?.didFetchPopularMovieData(to: movieList)
            }
        } catch {
            self.delegate?.didFetchPopularMovieData(to: [])
            print(error)
        }
    }
}
