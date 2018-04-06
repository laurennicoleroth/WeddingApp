//
//  Message.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 3/28/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Message {
  
  //MARK: Properties
  var owner: MessageOwner
  var type: MessageType
  var content: Any
  var timestamp: Int
  var isRead: Bool
  var image: UIImage?
  
  //MARK: Methods
  class func downloadAllMessage(completion: @escaping (Message) -> Swift.Void) {
    Database.database().reference().child("messages").observe(.value, with: { (snapshot) in
      if snapshot.exists() {
        let data = snapshot.value as! [String: String]
        let location = data["location"]
        
        print("Data", data)
        //TODO: complete implementation
      }
    })
  }
  
  func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
    if self.type == .photo {
      let imageLink = self.content as! String
      let imageURL = URL.init(string: imageLink)
      URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
        if error == nil {
          self.image = UIImage.init(data: data!)
          completion(true, indexpathRow)
        }
      }).resume()
    }
  }
  
  class func markMessagesRead(forUserID: String) {
    if let currentUserID = Auth.auth()?.currentUser?.uid {
      Database.database().reference().child("users").child(currentUserID).
    }
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

