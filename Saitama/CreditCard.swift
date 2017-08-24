//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  CreditCard.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import SwiftyJSON

public class CreditCard : BaseResult {
    
    var placeId : String!
    var number : String!
    var name : String!
    var cvv : String!
    var expiryMonth : String!
    var expiryYear : String!
    
    init(number : String, name : String, cvv : String, expiryMonth : String, expiryYear : String) {
        super.init()
        self.placeId = ""
        self.number = number
        self.name = name
        self.cvv = cvv
        self.expiryYear = expiryYear
        self.expiryMonth = expiryMonth
    }
    
    init(placeId : String, number : String, name : String, cvv : String, expiryMonth : String, expiryYear : String) {
        super.init()
        self.placeId = placeId
        self.number = number
        self.name = name
        self.cvv = cvv
        self.expiryYear = expiryYear
        self.expiryMonth = expiryMonth
    }
    
    override init() {
        
        super.init()
        self.placeId = ""
        self.number = ""
        self.name = ""
        self.cvv = ""
        self.expiryMonth = ""
        self.expiryYear = ""
        
    }
    
    // init with JSON object
    init(json: JSON) {
        
        self.placeId = ""
        self.number = ""
        self.name = ""
        self.cvv = ""
        self.expiryMonth = ""
        self.expiryYear = ""
        
        if let val = json["placeId"].string {
            self.placeId = val
        }
        
        if let val = json["number"].string {
            self.number = val
        }
        
        if let val = json["name"].string {
            self.name = val
        }
        
        if let val = json["cvv"].string {
            self.cvv = val
        }
        
        if let val = json["expiryMonth"].string {
            self.expiryMonth = val
        }
        if let val = json["expiryYear"].string {
            self.expiryYear = val
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
            "placeId" : self.placeId,
            "number" : self.number,
            "name" : self.name,
            "cvv" : self.cvv,
            "expiryMonth" : self.expiryMonth,
            "expiryYear" : self.expiryYear
        ]
    }
    
}
