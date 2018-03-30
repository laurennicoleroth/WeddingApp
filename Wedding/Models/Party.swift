//
//  Party.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 3/29/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Party {
  
  //MARK: Properties
  let user : User
  let lastMessage : Message
  
  //MARK: Methods
  class func showMessages(completion: @escaping ([Message]) -> Swift.Void) {
    if let currentUserID = Auth.auth().currentUser?.uid {
      print("We have a current user", currentUserID)
    }
  }
  
  init(user: User, lastMessage: Message) {
    self.user = user
    self.lastMessage = lastMessage
  }
}
