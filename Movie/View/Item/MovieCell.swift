//
//  MovieCell.swift
//  Movie
//
//  Created by admin on 24/10/24.
//

import Foundation
import UIKit
import Kingfisher

class MovieCell : UITableViewCell {
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    @IBOutlet weak var movieCategoryLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        movieRateLabel.textColor = UIColor.gray
        moviePosterImage.layer.cornerRadius = 8.0
        moviePosterImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func loadImage (url : String) {
        guard let url = URL(string: url) else {
            return
        }
        moviePosterImage?.kf.setImage(with: url)
    }
    
    func loadData (movie: MovieModel) {
        loadImage(url: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)")
        configDataView(movie: movie)
    }
    
    func configDataView(movie: MovieModel){
        movieTitleLabel?.text = movie.title
        movieRateLabel?.text = String(round((movie.voteAverage) * 10) / 10)
        movieCategoryLabel?.text = ""
        movieReleaseYearLabel?.text = String(movie.releaseDate.split(separator: "-").first ?? "2000")
        movieDurationLabel?.text = String()
    }
}
