//
//  HomeViewController.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/20.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
private let kTitleViewH : CGFloat = 40
class HomeViewController: UIViewController {

    //MARK : - 懒加载属性
   fileprivate  lazy var pageView : pateTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = pateTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    //控制器持有pagecontentview属性，pagecontentview中又有父控制器属性，可能会导致循环引用
    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        let contentH = kScreenH - kTitleViewH - kNavigationBarH - kStatusBarH - kTabbarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        var childVCs = [UIViewController]()
        childVCs.append(RecommendViewController())
        childVCs.append(GameViewController())
        childVCs.append(AmuseViewController())
        childVCs.append(FunnyViewController())
      let contentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentViewController: self)
        contentView.contentDelegate = self
        return contentView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

   
    

}

// MARK :- 设置UI界面
extension HomeViewController{
    fileprivate func setupUI(){
        automaticallyAdjustsScrollViewInsets = false
        //1.设置导航栏
        setupNavigationBar()
        //2.添加titleview
        view.addSubview(pageView)
        //3.添加pagecontentview
        view.addSubview(pageContentView)
    }
    
    fileprivate func setupNavigationBar(){
        //1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        //2.设置右边的item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem];
    }
}
//MARK: - 遵守pateTitleViewDelegate协议方法
extension HomeViewController : pateTitleViewDelegate{
    func pageTitleView(_ titleView: pateTitleView, selectedIndex index: Int) {
        //获取到当前点击的indexlabel --->传给pagecontentview
        pageContentView.setCurrentIndex(index)
    }
}


//MARK: - 遵守PageContentViewDelegate协议方法
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageView.setTitleViewProgress(progress, sourceIndex: sourceIndex, target: targetIndex)
    }
}
