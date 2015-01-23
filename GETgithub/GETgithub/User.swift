//
//  User.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/21/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class User
{
  var userName        : String
  var userAvatarURL   : NSURL
  var userAvatarImage : UIImage?

  init(jsonDictionary:[String:AnyObject])
  {
    self.userName      = jsonDictionary["login"] as String
    let url            = jsonDictionary["avatar_url"] as String
    self.userAvatarURL = NSURL(string: url)!
  }
  
  func updateImage(image:UIImage)
  {
    self.userAvatarImage = image as UIImage
  }
}