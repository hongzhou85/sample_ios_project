//  This is for project showcase only and not for commercial purposes. 
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  HistoryCell.swift
//  Saitama
//
//  Created by hongzhou, Joe on 23/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import UIKit

class HistoryCell : UITableViewCell {
    
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var email : UILabel!
    @IBOutlet weak var cardNumber : UILabel!
    @IBOutlet weak var placeId : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
    }
    
    required init(coder: NSCoder){
        super.init(coder:coder)!
    }
    
    func initUI(payment: Payment) {
        let updatedDate = payment.updatedAt.substring(to: 10)
        self.date.text = "on the \(updatedDate)"
        
        self.name.text = "\(payment.creditCard.name!)"
        self.email.text = "with email: \(payment.email!)"
        
        var number = "using card number : \(payment.creditCard.number.substring(to: 9))"
        for _ in 9...payment.creditCard.number.length {
            number += "x"
        }
        
        self.cardNumber.text = number
        self.placeId.text = "Reference place id: \(payment.placeId!)"
    }
}
