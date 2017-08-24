//  This is for project showcase only and not for commercial purposes. 
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//  
//  PaymentController.swift
//  Saitama
//
//  Created by hongzhou, Joe on 23/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email : tan.hongzhou@gmail.com

import Foundation
import UIKit
import SwiftValidator

protocol RentPopupDelegate {
    func rentNowPressed(cc : CreditCard)
    func cancelPressed()
}

class PaymentController: UIView, ValidationDelegate {
    
    var popupDelegate : RentPopupDelegate?
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var name : UITextField!
    @IBOutlet weak var creditCardNumber : UITextField!
    @IBOutlet weak var cvv : UITextField!
    @IBOutlet weak var month : UITextField!
    @IBOutlet weak var year : UITextField!
    @IBOutlet weak var rentNow : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var errorLabel : UILabel!
    
    let validator = Validator()     // Validation for the form input
    var place : Place!              // The place information for the payment, required to setup after creation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewFromNib = Bundle.main.loadNibNamed("PaymentView", owner: self, options: nil)!.first as! UIView
        viewFromNib.layer.shadowColor = UIColor.black.cgColor;
        viewFromNib.layer.shadowOffset = CGSize.zero;
        viewFromNib.layer.shadowRadius = 5.0;
        viewFromNib.layer.shadowOpacity = 0.5;
        viewFromNib.layer.cornerRadius = 10
        
        validator.registerField(name, errorLabel: errorLabel, rules: [RequiredRule()])
        validator.registerField(creditCardNumber, errorLabel: errorLabel, rules: [RequiredRule()])
        validator.registerField(month, errorLabel: errorLabel, rules: [RequiredRule()])
        validator.registerField(year, errorLabel: errorLabel, rules: [RequiredRule()])
        validator.registerField(cvv, errorLabel: errorLabel, rules: [RequiredRule()])
        
        self.addSubview(viewFromNib)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func onRentNowPressed(){
        
        resetErrors()
        validator.validate(self)
        
    }
    
    @IBAction func onCancelPressed(){
        self.popupDelegate?.cancelPressed()
    }
    
    func resetErrors() {
        errorLabel.text = ""
        
        name.layer.borderColor = UIColor.white.cgColor
        name.layer.borderWidth = 0.0
        
        creditCardNumber.layer.borderColor = UIColor.white.cgColor
        creditCardNumber.layer.borderWidth = 0.0
        
        month.layer.borderColor = UIColor.white.cgColor
        month.layer.borderWidth = 0.0
        
        year.layer.borderColor = UIColor.white.cgColor
        year.layer.borderWidth = 0.0
        
        cvv.layer.borderColor = UIColor.white.cgColor
        cvv.layer.borderWidth = 0.0
    }
    
    
    // Delegates for validations
    func validationSuccessful() {
        // submit the form
        
        let cc = CreditCard(placeId: place.id,
                            number: creditCardNumber.text!, name: name.text!,
                            cvv: cvv.text!, expiryMonth: month.text!, expiryYear: year.text!)
        
        self.popupDelegate?.rentNowPressed(cc: cc)
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                setVibrateAnimation(field)
            }
            error.errorLabel?.text = error.errorLabel?.text?.appending("\n \(error.errorMessage)") // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    
    deinit{
        #if DEBUG
            print("\(self) deinit")
        #endif
        
        popupDelegate = nil
    }
}
