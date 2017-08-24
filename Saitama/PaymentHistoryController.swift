//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  PaymentHistoryController.swift
//  Saitama
//
//  Created by hongzhou, Joe on 23/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email: tan.hongzhou@gmail.com

import Foundation
import UIKit
import SwiftValidator
import SwiftyJSON

class PaymentHistoryController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyLabel : UILabel!
    @IBOutlet weak var backButton : UIBarButtonItem!
    @IBOutlet weak var historyListTable : UITableView!
    
    var paymentList : [Payment] = []
    
    let paymentInterface = PaymentInterface()
    
    @IBAction func backPressed() {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        loadHistory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTable() {
        self.historyListTable.backgroundColor = UIColor.white
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        self.historyListTable.register(nib, forCellReuseIdentifier: "HistoryCell")
        
    }
    
    func loadHistory() {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: APP_TOKEN_KEY)
        paymentInterface.listPayment(token: token!).continueWith { task in
            if task.cancelled {
                showError(message: "Connection was cancelled. Try again.")
            } else if task.faulted {
                showError(message: (task.error?.localizedDescription)!)
            } else {
                let payments : [JSON] = (task.result?["payments"].array)!
                for p in payments {
                    let p : Payment = Payment(json: p)
                    self.paymentList.append(p)
                }
                if(self.paymentList.count > 0) {
                    self.emptyLabel.isHidden = true
                }
                self.historyListTable.reloadData()
            }
        }
    }
    
    // TableView delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let index = indexPath.row + indexPath.section
        let history = self.paymentList[index]
        
        cell.initUI(payment: history)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If required, add in action here for selection
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
