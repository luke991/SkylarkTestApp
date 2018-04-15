//
//  ViewControllerFactory.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

protocol ViewControllerFactory {
    func makeVideoSetListViewController() -> VideoSetListViewController
    func makeEpisodeDetailViewController(episode: Episode) -> EpisodeDetailViewController
}
