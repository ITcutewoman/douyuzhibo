//
//  NetworkTools.swift
//  DYZB
//
//  Created by 严子惠 on 2017/3/24.
//  Copyright © 2017年 严子惠. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType{
    case get
    case post
    
}
class NetworkTools: NSObject {

    //MARK:-封装网络请求方法
    //创建一个类方法
    class func requestData( _ type : MethodType ,URLString : String , parameters : [String : Any]? = nil,finishedCallBack : @escaping(_ result : Any) -> ()){
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error)
                return
            }
            
            // 4.将结果回调出去
            finishedCallBack(result)
        }
    }

}
