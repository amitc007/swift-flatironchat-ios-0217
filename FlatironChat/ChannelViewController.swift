//
//  InboxViewController.swift
//
//
//  Created by Johann Kerr on 3/23/17.
//
//

import UIKit
import Firebase

class ChannelViewController: UITableViewController {
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    var channels = [Channel]()
    var user: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        channels = []
        ref.child("channels").observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                //let channelItem = Channel(snapshot: item as! [String : [String : Any]])
                
                let channelItem = Channel(snapshot: item as! FIRDataSnapshot)
                self.channels.append(channelItem)
                print("ChannelViewController:item: \(item)")
                print("ChannelViewController:channels:\(self.channels)")
            }
            self.tableView.reloadData()
        })
        
    }
    
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "msgSegue" {
          
            if let dest = segue.destination as? MessageViewController {
                if let index = self.tableView.indexPathForSelectedRow?.row {
                    let channel = self.channels[index].name
                    dest.channelId = channel
                    dest.senderId = user
                    dest.senderDisplayName = user
                }
            }
        }
    }
    
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Create Channel", message: "Create a new channel", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Channel Name"
        }
        
        let create = UIAlertAction(title: "Create", style: .default) { (action) in
            if let channel = alertController.textFields?[0].text {
               
                self.ref.child("channels").child(channel).setValue(true) 
            }
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(create)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
 
}


extension ChannelViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath)
        
        cell.textLabel?.text = channels[indexPath.row].name
        cell.detailTextLabel?.text = channels[indexPath.row].lstMsg
        
        print("In ChannelViewController:cellForRowAt")
        
        return cell
    }
    
}
