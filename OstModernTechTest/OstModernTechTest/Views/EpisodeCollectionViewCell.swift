//
//  EpisodeCollectionViewCell.swift
//  OstModernTechTest
//
//  Created by Lucas Perger on 15/04/2018.
//  Copyright © 2018 Lucas Kuemmerle-Perger. All rights reserved.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var synopsisLbl: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    static let imageAspectRatio = CGFloat(96.0)/CGFloat(375.0)
    static let constantElementsHeight: CGFloat = 85
    
    var onFavouriteBtnTapped: (()->Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeholderImageView.isHidden = false
        mainImageView.image = nil
        titleLbl.text = nil
        synopsisLbl.text = nil
        toggleFavouriteBtnImage(isFavourited: false)
    }
    
    @IBAction func tappedFavouriteBtn(_ sender: Any) {
        onFavouriteBtnTapped?()
    }
    
    func toggleFavouriteBtnImage(isFavourited: Bool) {
        let image = UIImage(named: isFavourited ? "favouriteSaved" : "favouriteUnsaved")
        favouriteBtn.setImage(image, for: .normal)
    }
    
    static func contentHeight(forWidth width: CGFloat) -> CGFloat {
        let imageHeight = imageAspectRatio * width
        return imageHeight + constantElementsHeight
    }
}
