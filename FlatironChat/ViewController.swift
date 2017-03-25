//
//  ViewController.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/23/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    
    
    
    @IBOutlet weak var screenNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


    @IBAction func joinBtnPressed(_ sender: Any) {
        if let screenName = screenNameField.text {
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if error == nil {
                    /*let isAnonymous = user!.isAnonymous  // true
                    let uid = user!.uid*/
                    self.ref.child("users").child(screenName).setValue(true)
                    
                    //self.ref.child("users").
//                    user?. = screenName
                    print("in joinBtnPressed")

                }
                
                
            })
            
            
            UserDefaults.standard.set(screenName, forKey: "screenName")
            self.performSegue(withIdentifier: "openChannel", sender: self)
                
            
        } //if let screenName = screenNameField.text
        
    } //func joinBtnPressed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? ChannelViewController
        destVC?.user = screenNameField.text ?? "Invalid screeenname"
    }

}

