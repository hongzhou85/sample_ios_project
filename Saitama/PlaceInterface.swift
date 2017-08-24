//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  PlaceInterface.swift
//  Provides the Network interface to fetch the places for rental
//  Saitama
//
//  Created by hongzhou on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import Alamofire
import BoltsSwift
import SwiftyJSON

public class PlaceInterface : BaseInterface {
    
    override init() {
        super.init()
    }
    
    // GET /places/
    // Returns a promise according to the Places API response
    public func listRentalPlace() -> Task<JSON> {
        let taskCompletionSource = TaskCompletionSource<JSON>()
        
        let url = "\(getBaseUrl())/places"
        
        Alamofire.request(url)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    
                    taskCompletionSource.set(error: response.result.error!)
                    return
                }
                
                if let value = response.result.value {
                    // handle the results as JSON
                    let res = JSON(value)
                    taskCompletionSource.set(result: res)
                } else {
                    let res = BaseResult(code: 0, message: "NO RETURN JSON", val: NSDictionary())
                    taskCompletionSource.set(result: res.toJSON())
                }
        }
        
        return taskCompletionSource.task
    }
}
