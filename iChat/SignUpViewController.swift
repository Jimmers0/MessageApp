//
//  SignUpViewController.swift
//  iChat
//
//  Created by Hesham Abd-Elmegid on 10/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  @IBAction func didTapSignUp(sender: UIButton) {
    
    guard let name = nameField.text,
      let email = emailField.text,
      let password = passwordField.text,
      name.count > 0,
      email.count > 0,
      password.count > 0
      else {
        self.showAlert(message: "Enter a name, an email and a password.")
        return
    }
    
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if let error = error {
        if error._code == AuthErrorCode.invalidEmail.rawValue {
          self.showAlert(message: "Enter a valid email.")
        } else if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
          self.showAlert(message: "Email already in use.")
        } else {
          self.showAlert(message: "Error: \(error.localizedDescription)")
        }
        print(error.localizedDescription)
        return
      }
      
      if let user = user {
        self.setUserName(user: user, name: name)
        
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(user.uid)
        let values = ["name": name, "email": email, "friends": "Friend1"]
        usersReference.updateChildValues(values, withCompletionBlock: {
          (err, reff) in
          if err != nil {
            print(err ?? "no error print")
            return
          }
          print("User Saved to DB!")
        })
      }
    }
    
  }
  
  func setUserName(user: User, name: String) {
    let changeRequest = user.createProfileChangeRequest()
    changeRequest.displayName = name
    
    changeRequest.commitChanges(){ (error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      AuthenticationManager.sharedInstance.didLogIn(user: user)
      self.performSegue(withIdentifier: "ShowChatsFromSignUp", sender: nil)
    }
  }
  
  func showAlert(message: String) {
    let alertController = UIAlertController(title: "iChat", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}


