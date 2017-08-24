//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  Payment.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

public class Payment : BaseResult {
    
    var creditCard : CreditCard!
    var email : String!
    var placeId : String!
    var updatedAt : String!
    var createdAt : String!
    
    override init() {
        self.creditCard = CreditCard()
        self.email = ""
        self.placeId = ""
        self.updatedAt = ""
        self.createdAt = ""
        
        super.init()
    }
    
    // init with JSON object
    init(json: JSON) {
        self.creditCard = CreditCard()
        self.email = ""
        self.placeId = ""
        self.updatedAt = ""
        self.createdAt = ""
        
        if let val = json["updatedAt"].string {
            self.updatedAt = val
        }
        
        if let val = json["createdAt"].string {
            self.createdAt = val
        }
        
        if let val = json["email"].string {
            self.email = val
        }
        
        if let val = json["placeId"].string {
            self.placeId = val
        }
        
        if let val:JSON = json["creditCard"] {
            self.creditCard = CreditCard(json: val)
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
            "updatedAt" : self.updatedAt,
            "createdAt" : self.createdAt,
            "email" : self.email,
            "placeId" : self.placeId,
            "creditCard" : self.creditCard.toDictionary()
        ]
    }
    
}
