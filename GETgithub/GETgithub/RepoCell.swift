//
//  RepoCell.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

  
  @IBOutlet weak var userName: UILabel!
  
  @IBOutlet weak var repoContent: UILabel!
  
  @IBOutlet weak var language: UILabel!
  
  @IBOutlet weak var userAvatar: UIImageView!
  
 
  
  override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
  }

}
