//
//  Channel.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/24/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Channel {
    var name: String
    var lstMsg: String?
    var numberOfParticipants: Int

    init(snapshot: FIRDataSnapshot) {
        self.name = snapshot.key
        if let dict2 = snapshot.value as? [String:Any] {
            self.lstMsg = dict2["lastMessage"] as? String
        
            //print("dict2[participants]:\(dict2["participants"] )")
            if let dict3 = dict2["participants"] as? [String:Any] { //?? nil   //else { print("Invalid participants value"); numberOfParticipants = 0 ;  return  }
                self.numberOfParticipants = dict3.count
            }
        
        } //if let dict2 =
        numberOfParticipants = 0
        print("In Channel:name:\(self.name) lastMsg:\(self.lstMsg) numberOfParticipants:\(self.numberOfParticipants)")
    } //init
    
}
