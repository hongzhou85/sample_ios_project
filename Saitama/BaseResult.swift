//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  BaseResult.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

open class BaseResult : BaseObject {
    var code : Int
    var message : String
    
    var value : AnyObject   // Stores any other value object (NSDictionary) from return
    
    override init() {
        self.code = 0
        self.message = ""
        self.value = BaseObject()
        super.init()
    }
    
    init(code: Int, message: String, val: AnyObject) {
        self.code = code
        self.message = message
        self.value = val
    }
    
    // value may not be accurately converted
    override func toDictionary() -> NSDictionary {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict as NSDictionary
    }
    
    override func toJSON() -> JSON {
        
        return JSON(toDictionary())
    }
}
