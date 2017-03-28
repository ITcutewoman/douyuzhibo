//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/24.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit

class RecommendViewModel: NSObject {
    lazy var cycleModels :[cycleModel] = [cycleModel]()
    //懒加载组模型数组 数组是用来存放AnchorGroup模型的
     lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    //创建一个AnchorGroup模型 颜值
    fileprivate lazy var prettyGroup : AnchorGroup = AnchorGroup()
    //创建一个AnchorGroup模型 推荐
    fileprivate lazy var bigDataGroup : AnchorGroup = AnchorGroup()
}

extension RecommendViewModel {
    
    
   
   //发送网络请求 ----加载推荐数据
    
    func requestData( _ finishCallBack : @escaping() -> ()) {
        //将三组数据保存在anchorGroups里面，按照请求完的顺序保存
        //创建异步请求group
        let dGroup = DispatchGroup()
        //定义请求参数
        let parameters = ["limit":"4","offset":"0","time":Date.getCurrentDate()]
        //请求推荐数据
        dGroup.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : Date.getCurrentDate()]) { (result) in
            guard  let resultDic = result as? [String : NSObject] else{return}
            guard let dataArr = resultDic ["data"] as? [[String : NSObject]] else {return}
            
            for dic in dataArr {
                let anchorGroup  = AnchorModel(dict: dic)
                self.bigDataGroup.anchors.append(anchorGroup)
            }
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            dGroup.leave()
        }
        dGroup.enter()
         //请求颜值数据
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            guard  let resultDic = result as? [String : NSObject] else{return}
            guard let dataArr = resultDic ["data"] as? [[String : NSObject]] else {return}
         //   print("\(result)")
            for dic in dataArr{
                let anchor = AnchorModel(dict: dic)
                self.prettyGroup.anchors.append(anchor)
            }
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            dGroup.leave()
        }
         //请求游戏数据
        dGroup.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            //1.将rusult 转成字典类型
           guard  let resultDic = result as? [String : NSObject] else{return}
            guard let dataArr = resultDic ["data"] as? [[String : NSObject]] else {return}
            for dic in dataArr {
                //将字典转成模型并且保存在模型数组中
                let group = AnchorGroup(dict: dic)
                self.anchorGroups.append(group)
                
        
        }
            for group in self.anchorGroups{
             //  print("打印的数据：\(group.tag_name)")
            }
            
           dGroup.leave()
        }
        //三种数据请求完之后加入到anchorGroups中，按照顺序
        dGroup.notify(queue: DispatchQueue.main) {
            //bigDataGroup第一，prettyGroup排第二，游戏数据排第三
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallBack()
        }
        
    }
    
    func requestCycleData( _ finishCallBack : @escaping() -> ()){
        
        NetworkTools.requestData(.get, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version":"2.300"]) { (result) in
            guard let resultDic = result as? [String : NSObject] else{ return }
            guard let dicArr = resultDic["data"] as? [[String : NSObject]] else {return }
            for dic in dicArr{
            self.cycleModels.append(cycleModel(dict: dic))
        }
            finishCallBack()
    }
    
    
}
}
