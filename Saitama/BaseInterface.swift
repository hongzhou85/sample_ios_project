//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  BaseInterface.swift
//  Saitama
//  
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import Alamofire
import BoltsSwift
import SwiftyJSON

open class BaseInterface {
    
    let perPage : Int = 20
    
    init() {
        
    }
    
    // return empty string if settings.plist if tempered and the data is not available
    // Otherwise, return the base Url
    open func getBaseUrl() -> String {
        if let path = Bundle.main.path(forResource: "settings", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return dict["baseUrl"] as! String
            }
        }
        
        return ""
    }
    
    open static func testConnection() {
        
        let reachability: Reachability
        do {
            try reachability = Reachability()!
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                //print("Not reachable")
                showError(message: "No Internet connection detected.\nSwitch on Mobile data or Enable Wifi and restart the App again.")
                
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
