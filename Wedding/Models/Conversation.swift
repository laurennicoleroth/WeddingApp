//
//  Conversation.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 3/28/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Conversation {
  
  //MARK: Properties
  let user: User
  var lastMessage: Message
  
  //MARK: Methods
  class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
    if let currentUserID = Auth.auth().currentUser?.uid {
      var conversations = [Conversation]()
      Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
        if snapshot.exists() {
          let fromID = snapshot.key
          let values = snapshot.value as! [String: String]
          let location = values["location"]!
          User.info(forUserID: fromID, completion: { (user) in
            let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
            let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
            conversations.append(conversation)
            conversation.lastMessage.downloadLastMessage(forLocation: location, completion: {
              completion(conversations)
            })
          })
        }
      })
    }
  }
  
  //MARK: Inits
  init(user: User, lastMessage: Message) {
    self.user = user
    self.lastMessage = lastMessage
  }
}
