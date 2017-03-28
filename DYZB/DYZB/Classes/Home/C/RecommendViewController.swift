//
//  RecommendViewController.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/21.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

private let kHeaderViewH : CGFloat = 50
private let kItemMargin : CGFloat = 10

private let kGameViewH : CGFloat = 90
private let kCycleViewH  = kScreenW * 3/8
private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
private let kPrettyCellID = "kPrettyCellID"
let kNormalItemW = (kScreenW - 3 * kItemMargin)/2
let kNormalItemH = kNormalItemW * 3/4
let kPrettyItemH = kNormalItemW * 4/3
class RecommendViewController: UIViewController {
    fileprivate lazy var recommendVM : RecommendViewModel = RecommendViewModel()
    //懒加载无限轮播视图
    fileprivate lazy var cycleView : RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    //懒加载游戏colletionview
    fileprivate lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
    //懒加载collectionview
    fileprivate lazy var collectionView : UICollectionView = {[unowned self] in
       
        
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        //cell间隙
        layout.minimumInteritemSpacing = kItemMargin
        //头视图的size设置
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        //内边距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        //2.创建uicollectionview 
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

       collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)

        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
        loadData()
    }
    
   

}

extension RecommendViewController {
  fileprivate  func setupUI(){
        //1.添加collectionview
     self.view.addSubview(collectionView)
    
        //2.添加cycleview
    //随着colletionview要将控件添加到collectionview上，设置成负值坐标，colletcionviewtop往下移
    
    collectionView.addSubview(cycleView)
    
    //3.添加gameview
    collectionView.addSubview(gameView)
        //设置collectionview的内边距
    collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
    
    func loadData(){
        
        //1.加载推荐数据
        recommendVM.requestData {
            print("请求成功")
             self.collectionView.reloadData()
            
            //将数据传递给gameview
            var groups = self.recommendVM.anchorGroups
            self.gameView.groups = groups
        }
        //2.加载无限轮播数据
        recommendVM.requestCycleData {
            print("请求循环完成")
           self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
       
    }
}

extension RecommendViewController : UICollectionViewDelegate{
    
}
extension RecommendViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return recommendVM.anchorGroups[section].anchors.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        //取出模型对象
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        if indexPath.section == 1{
            let prettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            prettyCell.anchor = anchor
            return prettyCell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
            cell.anchor = anchor
            return  cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        return headerView
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int{
     return recommendVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if indexPath.section == 1{
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }else{
            return CGSize(width: kNormalItemW, height: kNormalItemH)
        }
    }

}
