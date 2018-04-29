//
//  Alerts.swift
//  iChat
//
//  Created by Jamie Randall on 4/28/18.
//  Copyright © 2018 CareerFoundry. All rights reserved.
//
import UIKit
import Foundation

class Alerts {
  func showAlert(title: String?, message: String?, actionTitle: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      topController.present(alertController, animated: true, completion: nil)
    }
  }
  
}
