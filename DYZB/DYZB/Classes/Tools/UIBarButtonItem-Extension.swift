//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/20.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    //便利构造函数  1> convenience开头 2> 在构造函数中必须明确调用一个设计的构造函数(self)
    //1.创建UIButton
    convenience init(imageName:String,highImageName:String = "",size:CGSize = CGSize.zero) {
        //1.创建UIButton
         let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: UIControlState())
        if highImageName != ""{
            btn.setImage(UIImage(named:highImageName), for: .highlighted)

        }
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)

        }
        self.init(customView:btn)
    }
   
    
}
