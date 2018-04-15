//
//  DependencyContainer.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class DependencyContainer {
    lazy var sharedNetworkService: NetworkService = URLSessionNetworkService()
    lazy var skylarkService: SkylarkService = SkylarkService(skylarkAPI: SkylarkAPI(networkService: self.sharedNetworkService), networkService: self.sharedNetworkService)
}

extension DependencyContainer: ViewControllerFactory {
    func makeVideoSetListViewController() -> VideoSetListViewController {
        let vc = UIStoryboard(name: "VideoSetList", bundle: nil).instantiateViewController(withIdentifier: "VideoSetListViewController") as! VideoSetListViewController
        vc.viewControllerFactory = self
        vc.skyLarkService = skylarkService
        vc.networkService = sharedNetworkService
        return vc
    }
    
    func makeEpisodeDetailViewController(episode: Episode) -> EpisodeDetailViewController {
        let vc = UIStoryboard(name: "EpisodeDetail", bundle: nil).instantiateViewController(withIdentifier: "EpisodeDetailViewController") as! EpisodeDetailViewController
        vc.episode = episode
        vc.skyLarkService = skylarkService
        vc.networkService = sharedNetworkService
        return vc
    }
}
