//
//  ChatViewController.swift
//  iChat
//
//  Created by Hesham Abd-Elmegid on 10/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import UserNotifications

class ChatViewController: MessagesViewController {
  var messages: [MessageType] = []
  var ref: DatabaseReference!
  private var databaseHandle: DatabaseHandle!
  
  
  var FriendsArray : [Person]?
  var myUser : Person?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    
    
    messageInputBar.delegate = self
    ref = Database.database().reference()
    messagesCollectionView.backgroundColor = .black
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    messages.removeAll()
    databaseHandle = ref.child("messages").observe(.childAdded, with: { (snapshot) -> Void in
      if let value = snapshot.value as? [String:AnyObject] {
        let id = value["senderId"] as! String
        
        if (self.myUser?.myFriends.contains(where: {$0.userID == id}))! || AuthenticationManager.sharedInstance.userID == id {
          print("FRIEND FOUND")
          let text = value["text"] as! String
          let name = value["senderDisplayName"] as! String
          
          let sender = Sender(id: id, displayName: name)
          let message = UserMessage(text: text, sender: sender, messageId: id, date: Date())
          self.messages.append(message)
          
          DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
          }
          
        }else{
          print("User not a friend! Messages hidden")
        }
      }
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.ref.removeObserver(withHandle: databaseHandle)
  }
  
  @IBAction func logOut(sender: UIBarButtonItem) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      AuthenticationManager.sharedInstance.loggedIn = false
      dismiss(animated: true, completion: nil)
    } catch let signOutError as NSError {
      print ("Error signing out: \(signOutError)")
    }
  }
}

extension ChatViewController: MessagesDataSource {
  
  func currentSender() -> Sender {
    let senderID = AuthenticationManager.sharedInstance.userID!
    let senderDisplayName = AuthenticationManager.sharedInstance.userName!
    
    return Sender(id: senderID, displayName: senderDisplayName)
  }
  
  func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }
}

extension ChatViewController: MessageInputBarDelegate {
  
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    let messageRef = ref.child("messages").childByAutoId()
    let message = [
      "text": text,
      "senderId": currentSender().id,
      "senderDisplayName": currentSender().displayName
    ]
    
    messageRef.setValue(message)
    inputBar.inputTextView.text = String()
  }
}

extension ChatViewController: MessagesDisplayDelegate {
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    if isFromCurrentSender(message: message) {
      return .blue
    } else {
      return .lightGray
    }
  }
  
  func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    if isFromCurrentSender(message: message) {
      return .white
    } else {
      return .darkText
    }
  }
  
  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    if isFromCurrentSender(message: message) {
      return .bubbleTail(.bottomRight, .curved)
    } else {
      return .bubbleTail(.bottomLeft, .curved)
    }
  }
}

extension ChatViewController: MessagesLayoutDelegate {
  func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }
  
  
  func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
    if isFromCurrentSender(message: message) {
      return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
    } else {
      return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    }
  }
  
  func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }
}
