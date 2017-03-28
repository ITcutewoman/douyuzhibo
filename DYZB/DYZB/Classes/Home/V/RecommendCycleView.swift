//
//  RecommendCycleView.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/27.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
private let kCycleViewID = "kCycleViewID"
class RecommendCycleView: UIView {
    var cycleTimer : Timer?
    var  cycleModels  : [cycleModel]?{
        didSet{
            collectionview.reloadData()
            pagecontrol.numberOfPages = cycleModels?.count ?? 0
            //默认滚动到中间某个位置   这里设置60的位置
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
            collectionview.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //在获取数据的时候添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置该控件不随父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        //注册cell
        collectionview.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleViewID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置colletionview的layout
        let layout = collectionview.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionview.bounds.size
    }
    
    
}
extension RecommendCycleView{
    class func recommendCycleView() ->RecommendCycleView{
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}

extension RecommendCycleView : UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
          //如果只有六个cell，滑倒最后一个以及第一个就没东西可滑啦，所以要加
        return (self.cycleModels?.count ?? 0) * 10000
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleViewID, for: indexPath) as! CollectionCycleCell
        cell.cycleModel = self.cycleModels![indexPath.item % cycleModels!.count]
        return cell
    }
}
extension RecommendCycleView : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滑倒一般跳下一个
        let offsetX = scrollView.contentOffset.x + (collectionview.bounds.width * 0.5)
        let currentPage = Int(offsetX / collectionview.bounds.width) % (cycleModels?.count ?? 1)
        pagecontrol.currentPage = currentPage
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}


extension RecommendCycleView{
    fileprivate func addCycleTimer() {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeCycleTimer(){
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
    @objc fileprivate func scrollToNext(){
        //获取当前的偏移量
        let currentOffsetX = collectionview.contentOffset.x
        let targetOffsetX = currentOffsetX + collectionview.bounds.width
        //
        collectionview.setContentOffset(CGPoint(x:targetOffsetX ,y :0 ), animated: true)
    }
}
