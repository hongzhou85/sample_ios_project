//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  BaeObject.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

//
protocol ModelModification {
    func toDictionary() -> NSDictionary
    func toJSON() -> JSON
}

open class BaseObject : ModelModification {
    
    init() {
        
    }
    
    func toDictionary() -> NSDictionary {
        return ["Inherit object": " needs to Override toJSON"]
    }
    
    func toJSON() -> JSON {
        return JSON(["Inherit object": " needs to Override toJSON"])
    }
}
