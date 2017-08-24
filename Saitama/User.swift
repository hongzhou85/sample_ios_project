//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  User.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

public class User : BaseResult {
    
    var email : String!
    var password : String!
    
    override init() {
        self.email = ""
        self.password = ""
        super.init()
    }
    
    init(email : String, password : String) {
        self.email = email
        self.password = password
        super.init()
    }
    
    // init with JSON object
    init(json: JSON) {
        self.email = ""
        self.password = ""
        
        if let val = json["email"].string {
            self.email = val
        }
        
        if let val = json["password"].string {
            self.password = val
        }
        
        super.init()
    }
    
    // Provide the JSON representation of the object
    override func toJSON() -> JSON {
        return JSON(toDictionary())
    }
    
    // Provide the dictionary representation of the Object
    override func toDictionary () -> NSDictionary {
        return [
            "email" : self.email,
            "password" : self.password
        ]
    }
}
