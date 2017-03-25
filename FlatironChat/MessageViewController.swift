//
//  MessageViewController.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/23/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseAuth

class MessageViewController: JSQMessagesViewController  {
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var messages = [JSQMessage]()
    var channelId = ""
    
    //static var lstMsgIndex = -1
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        getMessages()
        print("In MessageViewController:viewDidLoad:messages\(messages)")
    }
    
    
    
    
    func getMessages() {
        //messages = []
        ref.child("messages").child(channelId).observe(.value, with: { (snapshot) in
            for msg in snapshot.children {
                //let name = UserDefaults.standard.value(forKey: "screenName")
                let msg_s = msg as? FIRDataSnapshot
                if let msgDict = msg_s?.value as? [String:Any] {
                    print("msgDict:\(msgDict)")
                    if let jsq = JSQMessage(senderId: msgDict["from"] as? String, displayName: msgDict["from"] as? String, text: msgDict["content"] as? String) {
                        self.messages.append(jsq)
                        print("In MessageViewController:getMessages():jsq:\(jsq)")
                    }
                    print("In MessageViewController:getMessages():\(msg)")
                }
            }
            self.finishReceivingMessage()    //imp
        })
        
        
    }
    

    
    

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let name = UserDefaults.standard.value(forKey: "screenName")
        print("didPressSend:name:\(name)")
        if let jsqMsg = JSQMessage(senderId: name as! String!, senderDisplayName: name as! String!, date: date, text: text) {
            //messages.append(jsqMsg)
            ref.child("messages").child(channelId).childByAutoId().setValue(["from":name, "content":text])
        }
        //self.finishSendingMessage(animated: true)
        self.finishSendingMessage()
    }
    

}
//MARK: - CollectionView 


extension MessageViewController {
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        //if indexPath.row <= MessageViewController.lstMsgIndex { return nil }   //to avoid duplicate msgs
        print("MessageViewController:messageDataForItemAt:indexPath:\(indexPath.row) msg:\(messages[indexPath.item])")
        //MessageViewController.lstMsgIndex = indexPath.row
        
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}


//MARK: - Layout stuff


extension MessageViewController {
    
    fileprivate func setUpView() {
        collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
    }
    
    fileprivate func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    fileprivate func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
}
