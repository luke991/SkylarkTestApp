//
//  URLSessionNetworkService.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class URLSessionNetworkService: NetworkService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func performRequest(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?)->Void) {
        urlSession.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func performRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?)->Void) {
        urlSession.dataTask(with: request, completionHandler: completion).resume()
    }
}
