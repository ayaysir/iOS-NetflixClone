//
//  RecommendListViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/02.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import AVFoundation

class RecommendListViewController: UIViewController {

    @IBOutlet weak var sectionTitle: UILabel!
    
    
    let viewModel = RecommentListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        sectionTitle.text = viewModel.type.title
    }
}

extension RecommendListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.item(at: indexPath.item)
        cell.updateUI(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked", indexPath.item)
        let item = viewModel.item(at: indexPath.item)
        print(item)
        SearchAPI.search(item.searchKeyword, completion: { movies in
            guard let interstellar = movies.first else {
                return
            }
            
            let url = URL(string: interstellar.previewURL)!
            let item = AVPlayerItem(url: url)
            
            let storyBoard = UIStoryboard(name: "Player", bundle: nil)
            
            // 네트워크 작업과 분리
            DispatchQueue.main.async {
                let viewController = storyBoard.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
                viewController.player.replaceCurrentItem(with: item)
                
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: false, completion: nil)
            }
            
            
        })
    }
}


extension RecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class RecommentListViewModel {
    enum RecommendingType {
        case award
        case hot
        case my
        
        var title: String {
            switch self {
            case .award: return "아카데미 호평 영황"
            case .hot: return "취한저격 HOT 콘텐츠"
            case .my: return "내가 찜한 콘텐츠"
            
            }
        }
    }
    
    private (set) var type: RecommendingType = .my
    private var items: [DummyItem] = []
    
    var numOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> DummyItem {
        return items[index]
    }
    
    func updateType(_ type: RecommendingType) {
        self.type = type
    }
    
    func fetchItems() {
        self.items = MovieFetcher.fetch(type)
    }
}

class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func updateUI(movie: DummyItem) {
        thumbnailImage.image = movie.thumbnail
    }
    
    
    
    
    
}

class MovieFetcher {
    static func fetch(_ type: RecommentListViewModel.RecommendingType) -> [DummyItem] {
        switch type {
        case .award:
            let movies = (1..<10).map {
                DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!, searchKeyword: "totoro")
            }
            return movies
        case .hot:
            let movies = (10..<19).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!, searchKeyword: "batman") }
            return movies
        case .my:
            let movies = (1..<10).map { $0 * 2 }.map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!, searchKeyword: "Shutter island") }
            return movies
        }
    }
}

struct DummyItem {
    let thumbnail: UIImage
    let searchKeyword: String
}
