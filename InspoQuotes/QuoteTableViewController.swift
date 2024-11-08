//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit
class QuoteTableViewController: UITableViewController,SKPaymentTransactionObserver {
    
    
    let appleId = ""
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if checkIsPurchased() {
            showquotes()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if checkIsPurchased()
        {
            return quotesToShow.count
            
        }
        else {
            return quotesToShow.count + 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }
        else {
            cell.textLabel?.text = "Get More Quetoes"
            cell.textLabel?.textColor = .green
            cell.accessoryType = .disclosureIndicator
        }
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == quotesToShow.count {
            purchaseTheQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func purchaseTheQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKMutablePayment()
            request.productIdentifier = appleId
            SKPaymentQueue.default().add(request)
        }
        else {
            print("Cant make a payment")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("Succesfully purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                showquotes()
            }
            else if transaction.transactionState == .failed {
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Purches failed beucase of \(errorDescription)")
                }
                else if transaction.transactionState == .restored {
                    showquotes()
                    navigationItem.setRightBarButton(nil, animated: true)
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            
            }
        }
    }
    
    func showquotes() {
        quotesToShow.append(contentsOf: premiumQuotes)
        UserDefaults.standard.set(true, forKey: appleId)
        tableView.reloadData()
    }
    
    
    func checkIsPurchased() -> Bool {
        if UserDefaults.standard.bool(forKey: appleId) {
            return true
        }
        else {
            return false
        }
    }
    @IBAction func restorePressed(_ sender: UIBarButtonItem)
    {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }


}
