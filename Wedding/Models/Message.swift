//
//  Message.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 4/8/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import UIKit

class Message {
  var owner: MessageOwner
  var type: MessageType
  var content: Any
  var timestamp: Int
  var isRead: Bool
  var image: UIImage?
  
  
  //MARK: Inits
  init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
    self.type = type
    self.content = content
    self.owner = owner
    self.timestamp = timestamp
    self.isRead = isRead
  }
}
