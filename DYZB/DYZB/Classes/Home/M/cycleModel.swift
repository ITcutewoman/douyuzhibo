//
//  cycleModel.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/27.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

class cycleModel: NSObject {
    var title : String = ""
    var pic_url : String = ""
    //主播信息房间字典
    var room : [String : NSObject]?{
        didSet{
            guard let room = room else {return}
            anchor = AnchorModel(dict: room)
        }
    }
    //主播信息对应的模型对象
    var anchor : AnchorModel?
    
    //自定义构造函数
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
