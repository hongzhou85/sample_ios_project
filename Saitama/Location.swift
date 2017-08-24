//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  Location.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

public class Location : BaseResult {
    
    var lat : Double!
    var lng : Double!
    
    override init() {
        self.lat = 0.0
        self.lng = 0.0
        super.init()
    }
    
    // init with JSON object
    init(json: JSON) {
        self.lat = 0.0
        self.lng = 0.0
        
        if let val = json["lat"].string {
            self.lat = Double(val)
        }
        
        if let val = json["lng"].string {
            self.lng = Double(val)
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
            "lat" : self.lat,
            "lng" : self.lng
        ]
    }

}
