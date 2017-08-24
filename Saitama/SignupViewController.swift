//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  SignupViewController.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import UIKit
import SwiftValidator

class SignupViewController : UIViewController, ValidationDelegate {
    
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var confirmPasswordTextField : UITextField!
    @IBOutlet weak var closeButton : UIButton!
    @IBOutlet weak var signupButton : UIButton!
    @IBOutlet weak var errorLabel : UILabel!
    
    let userInterface = UserInterface()
    let validator = Validator()

    @IBAction func closeSignup() {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func userSignup() {
        
        resetErrors()
        validator.validate(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        validator.registerField(emailTextField, errorLabel: errorLabel, rules: [RequiredRule(),EmailRule(message: "Invalid email")])
        validator.registerField(passwordTextField, errorLabel: errorLabel, rules: [RequiredRule()])
        validator.registerField(confirmPasswordTextField, errorLabel: errorLabel, rules: [RequiredRule(),ConfirmationRule(confirmField: passwordTextField)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // private functions
    private func resetErrors() {
        
        errorLabel.text = ""
        
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 0.0
        
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 0.0
        
        confirmPasswordTextField.layer.borderColor = UIColor.white.cgColor
        confirmPasswordTextField.layer.borderWidth = 0.0
    }
    
    
    // Delegates
    func validationSuccessful() {
        // submit the form
        var email : String = emailTextField.text!
        var password : String = passwordTextField.text!
        
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let userInfo : User = User(email: email, password: password)
        userInterface.registerUser(userInfo: userInfo).continueWith { task in
            if task.cancelled {
                showError(message: "Connection was cancelled. Try again.")
            } else if task.faulted {
                showError(message: (task.error?.localizedDescription)!)
            } else {
                // Object was successfully saved
                let json = task.result
                if let code = json?["code"].number {
                    switch code {
                    case 1000:
                        showError(message: "Try another email. The email is taken.")
                    case 422:
                        showError(message: "Invaid submission. Try again.")
                    default :
                        showError(message: "Unknown Error Code Encountered: \(code)")
                    }
                } else {
                    let defaults = UserDefaults.standard
                    let token : String = (json?["token"].string)!
                    defaults.set(token, forKey: APP_TOKEN_KEY)
                    
                    let mapStoryboard = UIStoryboard(name: "MapView", bundle: nil)
                    let controller = mapStoryboard.instantiateInitialViewController()!
                    self.present(controller, animated: true, completion: {
                        
                    })
                }
            }
        }
        
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
}
