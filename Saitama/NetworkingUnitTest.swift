//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  NetworkingUnitTest.swift
//  Unit test to test all the integration of networking module
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingTest {
    
    var places : [Place] = []
    var token = ""
    let useremail : String = "saitama_\(randomString(3))@saitama.com"
    let password : String = "Q3u8Kre#="
    let creditCardNumber : String = "4000000000000002"
    let creditCardName : String = "Saitama"
    let cvv : String = "305"
    let expiryMonth : String = "03"
    let expiryYear : String = "2020"
    
    let userInterface = UserInterface()
    let placeInterface = PlaceInterface()
    let paymentInterface = PaymentInterface()
    
    // Test registration
    func test1() {
        
        let userInfo : User = User(email: useremail, password: password)
        
        // Case 1. register user
        userInterface.registerUser(userInfo: userInfo).continueWith { task in
            if task.cancelled {
                // Save was cancelled
                print("case 1 cancelled")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else if task.faulted {
                // Save failed
                print("case 1 failed : \(String(describing: task.error))")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else {
                // Object was successfully saved
                print("Case 1 Passed")
                print((task.result?.rawString())!+"\n\n")
                self.token = (task.result?["token"].string!)!
                
                self.test2()
            }
        }
    }
    
    // Test login
    func test2() {
        let userInfo : User = User(email: useremail, password: password)
        
        // Case 2. User login
        userInterface.loginUser(userInfo: userInfo).continueWith { task in
            if task.cancelled {
                // Save was cancelled
                print("case 2 cancelled")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else if task.faulted {
                // Save failed
                print("case 2 failed : \(String(describing: task.error))")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else {
                // Object was successfully saved
                print("Case 2 Passed")
                print((task.result?.rawString())!+"\n\n")
                self.token = (task.result?["token"].string!)!
                
                self.test3()
            }
        }
    }
    
    // Test listing of places
    func test3() {
        // 3. List Places
        placeInterface.listRentalPlace().continueWith { task in
            if task.cancelled {
                // Save was cancelled
                print("case 3 cancelled")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else if task.faulted {
                // Save failed
                print("case 3 failed : \(String(describing: task.error))")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else {
                // Object was successfully saved
                print("Case 3 Passed")
                print((task.result?.rawString())!+"\n\n")
                
                let jplaces : [JSON] = (task.result?["places"].arrayValue)!
                for place in jplaces {
                    let p : Place = Place(json: place)
                    self.places.append(p)
                }
                
                self.test4()
            }
        }
    }
    
    // Test create payment
    func test4() {
        let creditCard : CreditCard = CreditCard(number: creditCardNumber, name: creditCardName, cvv: cvv, expiryMonth: expiryMonth, expiryYear : expiryYear)
        
        creditCard.placeId = places[0].id
        
        // 4. add payment
        paymentInterface.createPayment(token: self.token, creditCard: creditCard).continueWith { task in
            if task.cancelled {
                // Save was cancelled
                print("case 4 cancelled")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else if task.faulted {
                // Save failed
                print("case 4 failed : \(String(describing: task.error))")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else {
                // Object was successfully saved
                print("Case 4 received response")
                print((task.result?.rawString())!+"\n\n")
                
                let code = task.result?["code"].number
                if(code == 1004) {
                    print("Case 4 Passed")
                }
                
                self.test5()
            }
        }
    }
    
    // Test Listing of payments
    func test5() {
        
        // 5. Request Payment
        paymentInterface.listPayment(token: self.token).continueWith { task in
            if task.cancelled {
                // Save was cancelled
                print("case 5 cancelled")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else if task.faulted {
                // Save failed
                print("case 5 failed : \(String(describing: task.error))")
                showError(message: (task.error?.localizedDescription)!)
                //exit(EXIT_FAILURE)
            } else {
                // Object was successfully saved
                print("Case 5 passed")
                print((task.result?.rawString())!+"\n\n")
                
            }
        }
    }
    
    public func startTest() {
        test1()
    }
    
}
