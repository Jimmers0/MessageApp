//
//  FriendsTableViewCell.swift
//  iChat
//
//  Created by Jamie Randall on 4/28/18.
//  Copyright © 2018 CareerFoundry. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
  @IBOutlet weak var checkBoxButton: UIButton!
  
  @IBOutlet weak var emailLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func checkBoxTapped(_ sender: Any) {
    if checkBoxButton.imageView?.image == #imageLiteral(resourceName: "openCheckBox") {
      checkBoxButton.setImage(#imageLiteral(resourceName: "checkedBox"), for: .normal)
    }else if checkBoxButton.imageView?.image == #imageLiteral(resourceName: "checkedBox") {
      checkBoxButton.setImage(#imageLiteral(resourceName: "openCheckBox"), for: .normal)
    }
    
  }
  
}
