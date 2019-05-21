//
//  UICollectionViewCell.swift
//  ShroomRoom
//
//  Created by Indrajit Chavan on 17/05/19.
//  Copyright © 2019 Indrajit Chavan. All rights reserved.
//

import UIKit
import expanding_collection

class UICollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
}
