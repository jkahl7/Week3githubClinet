//
//  UserDetailViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/21/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

  // after selecting a collectionView Cell in userSearch Collection view, this screen will be displayed with the users image & information
  
  var selectedUser      : User?
  var imageDestination  : CGRect?
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let image = self.selectedUser?.userAvatarImage
    {
      self.imageView.image  = image
      self.imageDestination = self.imageView.frame
    }
    println("transition to detail complete")
  }

    override func didReceiveMemoryWarning()
    {
      super.didReceiveMemoryWarning()
    }
}
