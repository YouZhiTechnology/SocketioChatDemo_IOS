//
//  JsonUtil.swift
//  kuaikaoti
//
//  Created by youzhi-air5 on 2021/3/4.
//  Copyright © 2021 GuoXiaolei. All rights reserved.
//

import UIKit
import HandyJSON


class JsonUtil: NSObject {

    //字典转json
    static func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    //json转字典
    static func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    /**
     *  Json转对象
     */
    static func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) ->BaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            #if DEBUG
            print("jsonoModel:字符串为空")
            #endif
            return BaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as! BaseModel
        
    }
    
    /**
     *  Json转数组对象(接收json字符串)
     */
    static func jsonStringToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[BaseModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            #if DEBUG
            print("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        var modelArray:[BaseModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.unicode)
        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray
        
    }
    
    /**
     *  Json转数组对象(接收json数组)
     */
    static func jsonArrayToModel(data: [Any], _ modelType:HandyJSON.Type) ->[BaseModel] {
        var modelArray:[BaseModel] = []
        for element in data {
            let tempModel = self.dictionaryToModel(element as! [String:Any], modelType)
            modelArray.append(tempModel)
        }
        return modelArray
    }
    
    
    /**
     *  字典转对象
     */
    static func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> BaseModel {
        if dictionStr.count == 0 {
            #if DEBUG
            print("dictionaryToModel:字符串为空")
            #endif
            return BaseModel()
        }
        return modelType.deserialize(from: dictionStr) as! BaseModel
    }
    
    /**
     *  对象转JSON
     */
    static func modelToJson(_ model:BaseModel?) -> String {
        if model == nil {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return ""
        }
        return (model?.toJSONString())!
    }
    
    /**
     *  对象转字典
     */
    static func modelToDictionary(_ model:BaseModel?) -> [String:Any] {
        if model == nil {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }
 
}
