//
//  ContactsViewController.swift
//  Flash Chat
//
//  Created by JM on 17-11-03.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ContactsViewController: UITableViewController {
    
    var contactArray = [["name" : "John Doe", "email" : "john.doe@email.com"], ["name" : "John Smith", "email" : "john.smith@email.com"], ["name" : "John Morris", "email" : "john.morris@email.com"]]

    
    @IBOutlet var contactTableView: UITableView!
    @IBOutlet var logOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize delegate and datasource
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        //TODO: Register your MessageCell.xib file here:
        contactTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell

        // Configure the cell...
        
        cell.avatarImageView.image = UIImage(named:"contact")
        
        cell.messageBody.text = contactArray[indexPath.row]["name"]
        
        cell.senderUsername.text = contactArray[indexPath.row]["email"]

        return cell
    }
 

    // This function is called whenever a cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        // Display Loading Icon
        SVProgressHUD.show()
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            
            // Return to the Welcome Page
            
            guard (navigationController?.popToRootViewController(animated: true)) != nil
                
                else{
                    print("No view controller to pop out")
                    return
            }
            
            SVProgressHUD.dismiss()
        }
        catch {
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */

}
