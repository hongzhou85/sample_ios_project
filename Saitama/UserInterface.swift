//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  UserInterface.swift
//  Provides the User networking interface to REST Api
//
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import Alamofire
import BoltsSwift
import SwiftyJSON

public class UserInterface : BaseInterface {
    
    override init() {
        super.init()
    }
    
    // PUT /users/
    // Register User
    // userInfo : The user information which includes the below:
    // email - The email used by the user to login
    // password - The password to login the user
    //
    // Return TASK with a promise according to the REST Api document
    public func registerUser(userInfo : User) -> Task<JSON> {
        let taskCompletionSource = TaskCompletionSource<JSON>()
        
        let url = "\(getBaseUrl())/users"
        
        Alamofire.request(url,
                          method: .put,
                          parameters: (userInfo.toDictionary() as! [String : AnyObject]),
                          encoding: JSONEncoding.default)
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
    
    // POST /users/
    // Login user with email and password
    // userInfo : The user information which includes the below:
    // email - The email used by the user to login
    // password - The password to login the user
    //
    // Return TASK with a promise
    public func loginUser(userInfo : User) -> Task<JSON> {
        let taskCompletionSource = TaskCompletionSource<JSON>()
        
        let url = "\(getBaseUrl())/users"
        
        Alamofire.request(url,
                          method: .post,
                          parameters: (userInfo.toDictionary() as! [String : AnyObject]),
                          encoding: JSONEncoding.default)
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

