//
//  ChannelListVC.swift
//  Wedding
//
//  Created by Lauren Nicole Roth on 4/6/18.
//  Copyright © 2018 Lauren Nicole Roth. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import FirebaseAuth

enum Section: Int {
  case createNewChannelSection = 0
  case currentChannelsSection
}

class ChannelListViewController: UITableViewController {
  
  // MARK: Properties
  var senderDisplayName: String?
  var newChannelTextField: UITextField?
  
  lazy var leftButton: UIBarButtonItem = {
    let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
    let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ChannelListViewController.showProfile))
    return button
  }()
  
  private var channelRefHandle: DatabaseHandle?
  private var channels: [Channel] = []
  
  private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    customization()
    
//    observeChannels()
    fetchData()
  }
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }
  
  //MARK : Methods
  
  func customization() {
    title = "Wedding Party"

    self.navigationItem.leftBarButtonItem = self.leftButton
  }
  
  //Downloads conversations
  func fetchData() {
    Channel.showChannels() { (channels) in
      self.channels = channels
      self.tableView.reloadData()
    }
  }
  
  // MARK :Actions
  @IBAction func createChannel(_ sender: AnyObject) {
    if let name = newChannelTextField?.text {
      let newChannelRef = channelRef.childByAutoId()
      let channelItem = [
        "name": name
      ]
      newChannelRef.setValue(channelItem)
    }
  }
  
  // MARK: Firebase related methods
  
  private func observeChannels() {
    // We can use the observe method to listen for new
    // channels being written to the Firebase DB
    channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
      let channelData = snapshot.value as! Dictionary<String, AnyObject>
      let id = snapshot.key
      if let name = channelData["name"] as! String!, name.count > 0 {
        
        self.tableView.reloadData()
      } else {
        print("Error! Could not decode channel data")
      }
    })
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let channel = sender as? Channel {
      let chatVc = segue.destination as! ChatVC
 
      if let currentUserEmail = Auth.auth().currentUser?.email {
        chatVc.senderDisplayName = currentUserEmail
      } else {
        chatVc.senderDisplayName = "Not Set"
      }
      
      chatVc.channel = channel
      chatVc.channelRef = channelRef.child(channel.id)
    }
  }
  
  //Shows profile extra view
  @objc func showProfile() {
    let info = ["viewType" : ShowExtraView.profile]
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    self.inputView?.isHidden = true
  }
  
  // MARK: UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let currentSection: Section = Section(rawValue: section) {
      switch currentSection {
      case .createNewChannelSection:
        return 1
      case .currentChannelsSection:
        return channels.count
      }
    } else {
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
      if let createNewChannelCell = cell as? CreateChannelCell {
        newChannelTextField = createNewChannelCell.newChannelNameField
      }
    } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
    }
    
    return cell
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      let channel = channels[(indexPath as NSIndexPath).row]
      self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }
  }
  
}
