//
//  Repo.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit


struct Repo
{
  var userName    : String
  var userRepo    : String
  var userRepoURL : String?
  var language    : String?
  var totalCount  : Int
  
  init(jsonDictionary : [String:AnyObject], totalCount : Int)
  {
    self.userName    = jsonDictionary["name"] as String
    self.userRepo    = jsonDictionary["description"] as String
    self.userRepoURL = jsonDictionary["html_url"] as? String
    self.language    = jsonDictionary["language"] as? String
    self.totalCount  = totalCount as Int
  }
}