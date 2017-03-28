//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/22.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var iconImageView: UIImageView!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    var group : AnchorGroup? {
        didSet{
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named:group?.icon_name ?? "home_header_normal")
        }
    }
}
