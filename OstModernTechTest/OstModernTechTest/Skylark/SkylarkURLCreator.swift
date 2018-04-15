//
//  SkylarkURLCreator.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 15/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class SkylarkURLCreator {
    private let host = URL(string: "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000")!
    
    func url(for request: SkylarkRequest) -> URL {
        switch request {
        case .sets:
            return host.appendingPathComponent("api/sets/")
        case .setDetail(let uid):
            return host.appendingPathComponent("api/sets/" + uid)
        case .episode(let url), .divider(let url), .image(let url):
            return host.appendingPathComponent(url.absoluteString)
        }
    }
}
