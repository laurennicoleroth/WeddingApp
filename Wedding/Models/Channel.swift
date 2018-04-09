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
    let channelsRef = Database.database().reference().child("channels")
    var channels = [Channel]()
    
    channelsRef.observe(.childAdded, with: { (snapshot) -> Void in
      if snapshot.exists() {
        let fromID = snapshot.key
        print(snapshot.value as! [String: Any])
        let values = snapshot.value as! [String: Any]
        let name = values["name"]
        channels.append(Channel(id: fromID, name: name as! String))
        completion(channels)
      }
    })
  }
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
  
  
}


