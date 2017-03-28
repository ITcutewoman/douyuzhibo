//
//  MainViewController.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/20.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //第一种初始化方法。
//        addChildVC(vcName: "Home")
//        addChildVC(vcName: "Live")
//        addChildVC(vcName: "Follow")
//        addChildVC(vcName: "Profile")
    }

    fileprivate func addChildVC(vcName:String){
        //通过storyboard获取控制器
        let childVC = UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController()!
        //将childvc 作为子控制器
        addChildViewController(childVC)
    }


}
