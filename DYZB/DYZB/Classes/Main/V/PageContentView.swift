//
//  PageContentView.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/21.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
private let contentCellID  = "contentCellID"
private var isForbidScrollDelegate : Bool = false
protocol PageContentViewDelegate : class {
    func pageContentView(_ contentView : PageContentView, progress : CGFloat , sourceIndex : Int, targetIndex : Int)
}
class PageContentView: UIView {

    //MARK : - 定义属性
    fileprivate var childVCs : [UIViewController]
    fileprivate weak var parentViewController : UIViewController?
    fileprivate var startIndex : CGFloat = 0
    weak var contentDelegate : PageContentViewDelegate?
    //懒加载collectionview
    fileprivate lazy var collectionview : UICollectionView = {
       //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建collectionview
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled  = true
        collectionView.bounces  = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectionView
    }()
    //MARK :- 自定义构造函数
    init(frame: CGRect,childVCs : [UIViewController], parentViewController : UIViewController?) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    //自定义构造函数要重写init方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

}
extension PageContentView{

    fileprivate func setupUI(){
        //1.将所有的子控制器添加到父控制器中
        for childVC in childVCs{
            parentViewController?.addChildViewController(childVC)
        }
        //2.添加collectionview来存放控制器的view
        addSubview(collectionview)
        collectionview.frame = self.bounds
    }
}

extension PageContentView : UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return childVCs.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        //2.防止复用
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
}

extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startIndex = scrollView.contentOffset.x
        
    }
    
    //滑动监听的方法--->sourceindex 、targetindex、 progress
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //判断是否是点击事件
        //如果不是点击事件，就不要实现下面的方法
        if isForbidScrollDelegate {return }
        
        
        let scrollViewW = scrollView.bounds.width
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        let currentIndex = scrollView.contentOffset.x
        if currentIndex > startIndex{//左滑
           
            //1.计算progress
            progress = currentIndex/scrollViewW - floor(currentIndex/scrollViewW)
            //2.计算sourceIndex
            sourceIndex = Int(currentIndex/scrollViewW)
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count{
                targetIndex = childVCs.count - 1
            }
            //4.刚好滑到一起
            if currentIndex - startIndex == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//右滑
            
            //1.计算progress
            progress = 1 - (currentIndex/scrollViewW - floor(currentIndex/scrollViewW))
            //3.计算targetIndex
            targetIndex = Int(currentIndex/scrollViewW)
            //2.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count{
                sourceIndex = childVCs.count - 1
            }
        }
        
        //设置代理，将这三个值传到titleview
        contentDelegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    

}

//MARK:-对外暴露的方法
extension PageContentView{
    func setCurrentIndex(_ currentIndex : Int) {
        
        isForbidScrollDelegate = true
        //滚动到正确的位置 --->点击titleview滑动的时候会调用scrollViewDidScroll代理方法，代理方法里又会调用代理方法，造成了循环
        let offsetX = CGFloat(currentIndex) * self.frame.width
        collectionview.setContentOffset(CGPoint(x:offsetX, y:0), animated: false)
    }
}
