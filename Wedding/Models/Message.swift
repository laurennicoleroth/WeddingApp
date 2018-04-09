//
//  Message.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 4/8/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class Message {
  var owner: MessageOwner
  var type: MessageType
  var content: Any
  var timestamp: Int
  var isRead: Bool
  var image: UIImage?
  
  //MARK: Methods
  class func observeMessages(forChannelID: String) {
    let channelRef = Database.database().reference().child("channels").child(forChannelID)
    channelRef.observe(.value, with: { (snapshot) in
      if snapshot.exists() {
        let receivedMessage = snapshot.value as! [String: Any]
        let messageType = receivedMessage["type"]
        print(messageType)
        //TODO: finish implementing observer of all messages for channel
      }
    })
  }
  
  class func send(message: Message, toChannel: String) {
    print("Sending message:", message)
  }
  
  
  //MARK: Inits
  init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
    self.type = type
    self.content = content
    self.owner = owner
    self.timestamp = timestamp
    self.isRead = isRead
  }
}
