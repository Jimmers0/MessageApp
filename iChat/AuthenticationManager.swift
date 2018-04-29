//
//  AuthenticationManager.swift
//  iChat
//
//  Created by Jamie Randall on 4/28/18.
//  Copyright © 2018 CareerFoundry. All rights reserved.
//
import Foundation
import Firebase
import FirebaseAuth

class AuthenticationManager: NSObject {
  
  static let sharedInstance = AuthenticationManager()
  
  var loggedIn = false
  var userName: String?
  var userID: String?
  var email: String?
  
  func didLogIn(user: User) {
    AuthenticationManager.sharedInstance.userName = user.displayName
    AuthenticationManager.sharedInstance.loggedIn = true
    AuthenticationManager.sharedInstance.userID = user.uid
    AuthenticationManager.sharedInstance.email = email 
  }
}
