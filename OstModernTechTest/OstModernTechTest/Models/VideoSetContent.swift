//
//  VideoSetContent.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 15/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

struct VideoSetContent: Codable {
    enum ContentType: String, Codable {
        case divider
        case episode
    }
    let position: Int
    let contentType: ContentType
    let contentURL: URL
    
    var concreteContent: ConcreteVideoSetContent?
}

extension VideoSetContent {
    enum CodingKeys: String, CodingKey {
        case position
        case contentType = "content_type"
        case contentURL = "content_url"
    }
}

