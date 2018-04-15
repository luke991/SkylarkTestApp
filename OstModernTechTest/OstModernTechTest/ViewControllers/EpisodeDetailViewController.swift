//
//  EpisodeDetailViewController.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 15/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var synopsisLbl: UILabel!
    var skyLarkService: SkylarkService?
    var networkService: NetworkService?
    var episode: Episode? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Episode Details"
        updateView()
    }
    
    private func updateView() {
        guard isViewLoaded else {
            return
        }
        titleLbl.text = episode?.title
        synopsisLbl.text = episode?.synopsis
        if let image = episode?.mainImage {
            setMainImage(image: image)
        } else if let imageURL = episode?.imageURLS.first {
            skyLarkService?.fetchImage(for: imageURL, completion: { [weak self] (result) in
                if case let .success(image) = result {
                    self?.networkService?.performRequest(image.url, completion: { (data, _, error) in
                        guard let data = data else {
                            return
                        }
                        DispatchQueue.main.async {
                            guard let image = UIImage(data: data) else {
                                return
                            }
                            self?.setMainImage(image: image)
                        }
                    })
                }
            })
        }
    }
    
    private func setMainImage(image: UIImage) {
        mainImageView.image = image
        placeholderImageView.isHidden = true
    }
}
