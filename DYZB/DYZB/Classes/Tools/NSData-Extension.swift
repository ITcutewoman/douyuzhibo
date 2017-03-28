
//
//  NSData-Extension.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/24.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import Foundation

extension Date{
    static func getCurrentDate() -> String{
         let nowData = Date()
        let interval = Int(nowData.timeIntervalSince1970)
        return "\(interval)"
    }
   
}
