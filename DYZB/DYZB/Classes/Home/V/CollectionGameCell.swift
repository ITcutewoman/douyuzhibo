//
//  CollectionGameCell.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/28.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var anchorGroup : AnchorGroup?{
        didSet{
            titleLabel.text = anchorGroup?.tag_name
            let iconUrl = URL(string: anchorGroup?.icon_url ?? "")
            iconImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named:"home_more_btn"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
