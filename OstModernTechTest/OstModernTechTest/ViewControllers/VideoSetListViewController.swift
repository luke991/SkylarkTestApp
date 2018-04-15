//
//  VideoSetListViewController.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class VideoSetListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var networkService: NetworkService?
    var skyLarkService: SkylarkService?
    var collectionViewData: [VideoSetContent] = []
    var viewControllerFactory: ViewControllerFactory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCollectionViewData()
    }
    
    private func fetchCollectionViewData() {
        skyLarkService?.fetchSets(completion: { [weak self] (result) in
            switch result {
            case .success(let sets):
                guard let homeSet = sets.first(where: {$0.slug == "home"}) else {
                    return
                }
                self?.collectionViewData = homeSet.items
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .error(let error):
                print(error.debugDescription)
                return
            }
        })
    }
}

extension VideoSetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        fetchAndReload(contentAt: indexPath)
    }
    
    private func fetchAndReload(contentAt indexPath: IndexPath) {
        let content = collectionViewData[indexPath.item]
        if content.concreteContent == nil {
            skyLarkService?.fetchContent(for: content, completion: { [weak self] (result) in
                switch result {
                case .success(let populatedContent):
                    self?.collectionViewData[indexPath.item] = populatedContent
                    DispatchQueue.main.async {
                        self?.collectionView.reloadItems(at: [indexPath])
                    }
                    if let episode = populatedContent.concreteContent as? Episode {
                        self?.skyLarkService?.fetchMainImage(for: episode, completion: { (result) in
                            if case let .success(modifiedEpisode) = result {
                                self?.collectionViewData[indexPath.item].concreteContent = modifiedEpisode
                                DispatchQueue.main.async {
                                    self?.collectionView.reloadItems(at: [indexPath])
                                }
                            }
                        })
                    }
                case .error(let error):
                    print(error.debugDescription)
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content = collectionViewData[indexPath.item]
        switch content.contentType {
        case .episode:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionViewCell", for: indexPath) as! EpisodeCollectionViewCell
            if let episode = content.concreteContent as? Episode {
                self.configure(cell: cell, with: episode)
            }
            return cell
        case .divider:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DividerCollectionViewCell", for: indexPath) as! DividerCollectionViewCell
            if let divider = content.concreteContent as? Divider {
                self.configure(cell: cell, with: divider)
            }
            return cell
        }
    }
    
    private func configure(cell: DividerCollectionViewCell, with divider: Divider) {
        cell.nameLbl.text = divider.name
    }
    
    private func configure(cell: EpisodeCollectionViewCell, with episode: Episode) {
        cell.titleLbl.text = episode.title
        cell.synopsisLbl.text = episode.synopsis
        cell.toggleFavouriteBtnImage(isFavourited: FavouritesManager.shared.isFavourited(episode: episode))
        cell.mainImageView.image = episode.mainImage
        cell.onFavouriteBtnTapped = {
            FavouritesManager.shared.toggleFavourite(episode: episode)
            cell.toggleFavouriteBtnImage(isFavourited: FavouritesManager.shared.isFavourited(episode: episode))
        }
    }
}

extension VideoSetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let content = collectionViewData[indexPath.item]
        let fullWidth = collectionView.bounds.size.width
        switch content.contentType {
        case .episode:
            return CGSize(width: fullWidth, height: EpisodeCollectionViewCell.contentHeight(forWidth: fullWidth))
        case .divider:
            return CGSize(width: fullWidth, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = collectionViewData[indexPath.item]
        switch content.contentType {
        case .episode:
            guard let episode = content.concreteContent as? Episode,
                let episodeVC = viewControllerFactory?.makeEpisodeDetailViewController(episode: episode) else {
                    return
            }
            navigationController?.pushViewController(episodeVC, animated: true)
        case .divider:
            return
        }
    }
}
