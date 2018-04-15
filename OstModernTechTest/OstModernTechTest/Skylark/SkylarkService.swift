//
//  SkylarkService.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 14/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(T)
    case error(Error?)
}

class SkylarkService {
    let skylarkAPI: SkylarkAPI
    let networkService: NetworkService
    
    init(skylarkAPI: SkylarkAPI, networkService: NetworkService) {
        self.skylarkAPI = skylarkAPI
        self.networkService = networkService
    }
    
    func fetchSets(completion: @escaping (Result<[VideoSet]>)->Void) {
        skylarkAPI.performRequest(for: VideoSetList.self, request: SkylarkRequest.sets) { (result) in
            switch result {
            case .success(let setList):
                completion(.success(setList.objects))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func fetchEpisode(for urlComponent: URL, completion: @escaping (Result<Episode>)->Void) {
        skylarkAPI.performRequest(for: Episode.self, request: SkylarkRequest.episode(contentURL: urlComponent), completion: completion)
    }
    
    func fetchDivider(for urlComponent: URL, completion: @escaping (Result<Divider>)->Void) {
        skylarkAPI.performRequest(for: Divider.self, request: SkylarkRequest.divider(contentURL: urlComponent), completion: completion)
    }
    
    func fetchImage(for urlComponent: URL, completion: @escaping (Result<Image>)->Void) {
        skylarkAPI.performRequest(for: Image.self, request: .image(contentURL: urlComponent), completion: completion)
    }
    
    func fetchContent(for content: VideoSetContent, completion: @escaping (Result<VideoSetContent>)->Void) {
        let url = content.contentURL
        switch content.contentType {
        case .episode:
            fetchEpisode(for: url) {(result) in
                switch result {
                case .success(let episode):
                    var populatedContent = content
                    populatedContent.concreteContent = episode
                    completion(.success(populatedContent))
                case .error(let error):
                    completion(.error(error))
                }
            }
        case .divider:
            fetchDivider(for: url) { (result) in
                switch result {
                case .success(let episode):
                    var populatedContent = content
                    populatedContent.concreteContent = episode
                    completion(.success(populatedContent))
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
    }
    
    func fetchMainImage(for episode: Episode, completion: @escaping (Result<Episode>)->Void) {
        if let imageURL = episode.imageURLS.first {
            fetchImage(for: imageURL, completion: { [weak self] (result) in
                switch result {
                case .success(let image):
                    self?.networkService.performRequest(image.url, completion: { (data, _, error) in
                        guard let data = data else {
                            completion(.error(error))
                            return
                        }
                        var modifiedEpisode = episode
                        modifiedEpisode.mainImage = UIImage(data: data)
                        completion(.success(modifiedEpisode))
                    })
                default: return
                }
            })
        }
    }
}
