//  This is for project showcase only and not for commercial purposes.
//  Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  Common.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import UIKit
import AVFoundation
import SCLAlertView

let APP_TOKEN_KEY = "com.saitama.token"
let SAITAMA_LAT = 35.781557
let SAITAMA_LNG = 139.721341

// Provide subscript functionality to String class to access characters and range.
extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}

func showError(message : String) {
    SCLAlertView().showWarning("Something went wrong", subTitle: message)
}

// Vibrate a View to highlight and notify required action to the user
func setVibrateAnimation(_ view: UIView) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 6
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
    view.layer.add(animation, forKey: "position")
}

// Generate random string
// length : the length of the random string
// By default, it will return at least 1 character
func randomString(_ length: Int) -> String {
    let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var string = "\(Int(arc4random_uniform(10)))"
    
    if(length <= 1) {
        return string
    }
    
    for _ in 1...length {
        let idx = (Int(arc4random_uniform(UInt32(charactersString.length))))
        string += charactersString[idx]
    }
    
    return string
}

func randomRating() -> Int {
    
    return Int(arc4random_uniform(5))+1
}
