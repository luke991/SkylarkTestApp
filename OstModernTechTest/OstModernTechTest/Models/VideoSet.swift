//
//  VideoSet.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

struct VideoSet: Codable {
    let uid: String
    let slug: String
    let items: [VideoSetContent]
}

