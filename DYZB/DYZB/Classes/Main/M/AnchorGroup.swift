//
//  AnchorGroup.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/24.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    //该组对应的房间信息
    var  room_list : [[String : NSObject]]? {
        //didSet 属性改变的时候调用的方法
        //判断房间信息数组为空就return
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    var  tag_name : String = ""
    var  icon_url : String = ""
    //组显示的图标
    var icon_name : String = "home_header_normal"
    
    //自定义构造函数
    override init(){
        
    }
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
   
}
