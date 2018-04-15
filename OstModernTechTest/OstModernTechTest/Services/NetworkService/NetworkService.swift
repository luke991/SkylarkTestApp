//
//  NetworkService.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

protocol NetworkService {
    func performRequest(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?)->Void)
    func performRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?)->Void)
}

