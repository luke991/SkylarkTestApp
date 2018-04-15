//
//  Skylark.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

enum SkylarkRequest {
    case sets
    case setDetail(uid: String)
    case episode(contentURL: URL)
    case divider(contentURL: URL)
    case image(contentURL: URL)
}

enum SkylarkError: Error {
    case unknown
}


class SkylarkAPI: NSObject {
    private let networkService: NetworkService
    private let skylarkURLCreator: SkylarkURLCreator
    
    init(networkService: NetworkService, skylarkURLCreator: SkylarkURLCreator = SkylarkURLCreator()) {
        self.networkService = networkService
        self.skylarkURLCreator = skylarkURLCreator
    }
    
    func performRequest<T: Codable>(for returnType: T.Type, request: SkylarkRequest, completion: @escaping (Result<T>)->Void) {
        let url = skylarkURLCreator.url(for: request)
        networkService.performRequest(url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completion(.error(error))
                } else {
                    completion(.error(SkylarkError.unknown))
                }
                return
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch let error {
                completion(.error(error))
            }
        }
    }
}
