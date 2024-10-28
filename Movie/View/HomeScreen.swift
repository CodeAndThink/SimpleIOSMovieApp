//
//  HomeScreen.swift
//  Movie
//
//  Created by admin on 23/10/24.
//

import Foundation
import UIKit
import MBProgressHUD

class HomeScreen : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel : MainViewModel?
    var isLoading = false
    var datas : [MovieModel?] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadUi()
    }
    
    func loadUi() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadData() {
        viewModel = MainViewModel.shared()
        viewModel?.delegate = self
        Task {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            await viewModel?.fetchPopularMovieData(page: page)
        }
    }
    
    func loadMore() {
        page += 1
        Task {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            await viewModel?.fetchPopularMovieData(page: page)
        }
    }
}

extension HomeScreen : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        if let data = datas[indexPath.row] {
            cell.loadData(movie: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = datas[indexPath.row]
        performSegue(withIdentifier: "showDetailSegue", sender: selectedMovie)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        
        if let lastVisibleIndexPath = visibleIndexPaths.last, lastVisibleIndexPath.row == datas.count - 1 {
            loadMore()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetailSegue" {
                let detailVC = segue.destination as! DetailScreen
                if let selectedMovie = sender as? MovieModel {
                    detailVC.movie = selectedMovie
                }
            }
        }
}

extension HomeScreen : FetchMovieViewModelDelegate {
    func didFetchPopularMovieData(to datas: [MovieModel]) {
        self.datas += datas
        DispatchQueue.main.async {
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
