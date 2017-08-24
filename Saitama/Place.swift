//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//  
//  Place.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

public class Place : BaseResult {
    
    var updatedAt : String!
    var createdAt : String!
    var id : String!
    var name : String!
    var location : Location!
    
    
    override init() {
        self.updatedAt = ""
        self.createdAt = ""
        self.id = ""
        self.name = ""
        self.location = Location()
        super.init()
    }
    
    // init with JSON object
    init(json: JSON) {
        self.updatedAt = ""
        self.createdAt = ""
        self.id = ""
        self.name = ""
        self.location = Location()
        
        if let val = json["updatedAt"].string {
            self.updatedAt = val
        }
        
        if let val = json["createdAt"].string {
            self.createdAt = val
        }
        
        if let val = json["id"].string {
            self.id = val
        }
        
        if let val = json["name"].string {
            self.name = val
        }
        
        if let val:JSON = json["location"] {
            self.location = Location(json: val)
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
            "udpatedAt" : self.updatedAt,
            "createdAt" : self.createdAt,
            "id" : self.id,
            "name" : self.name,
            "location" : location.toDictionary()
        ]
    }
}
