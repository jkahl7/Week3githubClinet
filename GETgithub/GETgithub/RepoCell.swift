//
//  RepoCell.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell
{
  @IBOutlet weak var backgroundImage  : UIImageView!
  @IBOutlet weak var userName         : UILabel!
  @IBOutlet weak var repoContent      : UILabel!
  @IBOutlet weak var language         : UILabel!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
  }
}
