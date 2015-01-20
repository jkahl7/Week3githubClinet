//
//  Repo.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit


struct Repo {
  
  let owner:[String:AnyObject]
  
  let userName:String
  let userRepo:String
  let userAvatarURL:String
  let language:String
  
  var userAvatar:UIImage?
  
  init(jsonDictionary:[String:AnyObject]) {
    self.owner = jsonDictionary["owner"] as [String:AnyObject] // index into the owner dictionary
    
    self.userName = jsonDictionary["name"] as String
    self.userRepo = jsonDictionary["description"] as String
    self.language = jsonDictionary["language"] as String
    self.userAvatarURL = self.owner["avatar_url"] as String
  }
}