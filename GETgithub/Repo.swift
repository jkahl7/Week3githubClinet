//
//  Repo.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit


struct Repo {
  
  var userName:String
  var userRepo:String
  var language:String?
  
  init(jsonDictionary:[String:AnyObject]) {
    self.userName = jsonDictionary["name"] as String
    self.userRepo = jsonDictionary["description"] as String
    self.language = jsonDictionary["language"] as? String
  }
}