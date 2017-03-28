//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/22.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionPrettyCell: UICollectionViewCell {

    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var anchor : AnchorModel?{
        didSet{
            //1.校验模型是否有值
            guard let anchor = anchor else {
                return
            }
            //2.取出在线人数显示的文字
            var onlineStr : String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online/10000))万在线"
            }else{
                onlineStr = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)
            //3.昵称的显示
            nickNameLabel.text = anchor.nickname
            
            //4.封面图片
            guard  let iconURL = URL(string: anchor.vertical_src) else {return}
            iconImageView.kf.setImage(with: iconURL)
            //5.城市btn
            cityBtn.setTitle(anchor.anchor_city, for: .normal)
        }
    }
     

}
