//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  PaymentInterface.swift
//  Saitama
//
//  Created by hongzhou on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import Alamofire
import BoltsSwift
import SwiftyJSON

public class PaymentInterface : BaseInterface {
    
    override init() {
        super.init()
    }
    
    // PUT / payments/
    // Requires token
    // token: The token for the user
    // placeId : The place id
    // creditCard : The credit card information of the user
    //
    //
    public func createPayment(token : String, creditCard : CreditCard) -> Task<JSON> {
        let taskCompletionSource = TaskCompletionSource<JSON>()
        
        let headers = [
            "Authorization" : "Bearer \(token)"
        ]
        
        
        
        let url = "\(getBaseUrl())/payments"
        
        Alamofire.request(url,
                          method: .put,
                          parameters: (creditCard.toDictionary() as! [String : AnyObject]),
                          headers: headers)
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
    
    // GET / payments/
    // token : The token for the user
    //
    // Return TASK with a promise
    // A list the existing payment method, if any
    public func listPayment(token : String) -> Task<JSON> {
        let taskCompletionSource = TaskCompletionSource<JSON>()
        
        let headers = [
            "Authorization" : "Bearer \(token)"
        ]
        
        let url = "\(getBaseUrl())/payments"
        
        Alamofire.request(url,
                          method: .get,
                          headers: headers)
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
