//
//  AlertView.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/22/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class AlertView: UIView
{
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  @IBOutlet weak var alertLabel   : UILabel!
  
  @IBAction func alertButton(sender: UIButton)
  {
    let netCont = appDelegate.netController
    netCont.requestAccessToken()
  }
  override func awakeFromNib()
  {
    super.awakeFromNib()
  }
}
