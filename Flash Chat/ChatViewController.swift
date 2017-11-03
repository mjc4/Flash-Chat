//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // Configure the table view
        configureTableView()
        
        // remove cell border separator
        messageTableView.separatorStyle = .none
        
        // retrieve messages from the DB
        retrieveMessages()
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    

    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This method aims to reuse a custom cell
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //set the message body
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        
        // set the sender label to the username logged in
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        //set the avatar
        cell.avatarImageView.image = UIImage(named: "egg")
        
        // Customize Avatar and Color of the background of messages
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            
            cell.avatarImageView.backgroundColor = UIColor.flatSand()
            cell.messageBackground.backgroundColor = UIColor.flatLime()
        }
        else{
            cell.avatarImageView.backgroundColor = UIColor.flatPlum()
            cell.messageBackground.backgroundColor = UIColor.flatOrange()
        }
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        //resize the height of the cell to be automatic according to the text size of the cell
        messageTableView.rowHeight = UITableViewAutomaticDimension
        
        // give an estimate height but will be automatically resize if the height of the row is > 120
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Set the animation
        UIView.animate(withDuration: 0.5) {
            // set the height constraint of the view to be above the keyboard: around 380
            self.heightConstraint.constant = 300
            // reload the view with the new constraint
            self.view.layoutIfNeeded()
        }
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Set the animation
        UIView.animate(withDuration: 0.5) {
            // set the height constraint to its default value back
            self.heightConstraint.constant = 50
            // reload the view with the new constraint
            self.view.layoutIfNeeded()
        }
        
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Receive from Firebase

    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        // signal the end of editing
        messageTextfield.endEditing(true)
        
        // disable the button and textfield
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //TODO: Send the message to Firebase and save it in our database
        
        // create a message DB to keep our messages
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            
            (error, ref) in
            
            if (error != nil) {
                print(error!)
            }
            else{
                // Bring back the textfield  and the button at its default position
                print("message saved")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        
        let messageDB = Database.database().reference().child("Messages")
        
        // Observe to an event type added then retrieve the message
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapValue = snapshot.value as! [String:String]
            
            let message = Message()
            
            message.messageBody = snapValue["MessageBody"]!
            message.sender = snapValue["Sender"]!
            
            self.messageArray.append(message)
            
            // reformat the table view and reload data on the table view
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    


}
