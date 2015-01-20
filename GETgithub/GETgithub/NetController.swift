//
//  NetController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import Foundation

class NetController {
  //need fetch method to gather github JSON data
  
  //this urlSession can be used by multiple methods
  var urlSession:NSURLSession
  
  let url = NSURL(string:"http://127.0.0.1:3000")
  
  init (){
    let ephemeralConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfiguration)
  }
  
  func fetchRepoForSearchTerm(searchTerm:String, callback:(repo:[Repo]?, error:String?) -> (Void)) {
    let dataTask = self.urlSession.dataTaskWithURL(self.url!, completionHandler: { (data, response, error) -> Void in
      if(error == nil) { // cast response into NSHTTPURLResponse  to get source codes
        var error:NSError?
        if let rawJSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String:AnyObject] {
          var repo = Array<Repo>()
          if let jsonArray = rawJSON["items"] as? [AnyObject] { // jsonArray is an array of dictionaries
            for dictionary in jsonArray {
              if let dictReadyForRepo = dictionary as? [String:AnyObject] {
                let info = Repo(jsonDictionary: dictReadyForRepo)
                repo.append(info)
              }
            }
            callback(repo: repo, error: "GTG")
          }
        }
      }
    })
    dataTask.resume()
  }

  
}