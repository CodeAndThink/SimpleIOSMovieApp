//
//  DetailScreen.swift
//  Movie
//
//  Created by admin on 23/10/24.
//

import Foundation
import UIKit
import Kingfisher
import MBProgressHUD

class DetailScreen : UIViewController {
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UITextView!
    @IBOutlet weak var movieRateButton: UIButton!
    @IBOutlet weak var movieYearReleaseLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieCategoryLabel: UILabel!
    
    var viewModel : DetailViewModel?
    var movie : MovieModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func loadData () {
        viewModel = DetailViewModel()
        viewModel?.deligate = self
        Task {
            await viewModel?.fetchMovieDetail(movieId: movie!.id)
        }
    }
    
    func loadUi() {
        guard let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(movie!.backdropPath)" ) else {
            return
        }
        guard let posterUrl = URL(string:  "https://image.tmdb.org/t/p/w500/\(movie!.posterPath)") else {
            return
        }
        posterImage.kf.setImage(with: posterUrl)
        backDropImage.kf.setImage(with: backdropUrl)
        movieNameLabel?.text = movie?.title ?? ""
        movieRateButton?.setTitle(String(round((movie?.voteAverage ?? 5.0) * 10) / 10), for: .normal)
        movieOverviewLabel?.text = movie?.overview ?? ""
        movieYearReleaseLabel?.text = String(movie?.releaseDate.split(separator: "-").first ?? "2000")
        movieDurationLabel?.text = "\(String(movie?.duration ?? 0)) Minutes"
        movieCategoryLabel?.text = movie?.genres?.first?.genreName
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        posterImage.kf.cancelDownloadTask()
        backDropImage.kf.cancelDownloadTask()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
}

extension DetailScreen : FetchMovieDetailDataDeligate {
    func didFetchMovieDetail(to movie: MovieModel) {
        self.movie = movie
        DispatchQueue.main.async {
            self.loadUi()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
