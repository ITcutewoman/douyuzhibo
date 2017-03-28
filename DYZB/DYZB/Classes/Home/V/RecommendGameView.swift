//
//  RecommendGameView.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/28.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
private let kGameCellID = "kGameCellID"
class RecommendGameView: UIView {
    var groups : [AnchorGroup]?{
        didSet{
            //移除前面两组，添加更多的组
            groups?.removeFirst()
            groups?.removeFirst()
            
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups?.append(moreGroup)
            
            self.collectionVew.reloadData()
        }
    }
    @IBOutlet weak var collectionVew: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //让控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        //注册cell
        collectionVew.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
    }

}

extension RecommendGameView{
    class func recommendGameView() -> RecommendGameView{
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}

extension RecommendGameView : UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.groups?.count ?? 0
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        cell.anchorGroup = self.groups![indexPath.item]
        return cell
    }
}
