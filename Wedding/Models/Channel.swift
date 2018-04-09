//
//  Channel.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 4/6/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import Firebase


class Channel {
  
  internal let id: String
  internal let name: String
  
  class func showChannels(completion: @escaping ([Channel]) -> Swift.Void) {
    var channels = [Channel]()
    
    Database.database().reference().child("channels").observe(.childAdded, with: { (snapshot) in
      if snapshot.exists() {
        let fromID = snapshot.key
        let value = snapshot.value as! [String: String]
        
        print("FromID \(fromID), \(value)")
      }
    })
  }
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
  
  
}


