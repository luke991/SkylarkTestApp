//
//  Episode.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 15/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

struct Episode: ConcreteVideoSetContent, Codable {
    let uid: String
    let title: String
    let synopsis: String
    let imageURLS: [URL]
    var mainImage: UIImage?
}

extension Episode {
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case title = "title"
        case synopsis = "synopsis"
        case imageURLS = "image_urls"
    }
}
