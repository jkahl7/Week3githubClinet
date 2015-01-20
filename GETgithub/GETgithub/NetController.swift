//
//  NetController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class NetworkController {
  class var sharedNetworkController:NetworkController {
    struct Static {
      static let instance:NetworkController = NetworkController()
    }
    return Static.instance
  }
  
  //need fetch method to gather github JSON data
  
  //this urlSession can be used by multiple methods
  var urlSession:NSURLSession
  
  let clientID = "e3ecc12cc38533806169"
  
  let clientSeacret = "60394bb88b65cf8df87088c6556b604ca5c4cf46"
  
  var accessToken:String?
  
  let accessTokenKey = "accessTokenKey"
  
  init () {
    //Returns a session configuration that uses no persistent storage for caches, cookies, or credentials.
    let ephemeralConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfiguration)
    
    if let keyCheck = NSUserDefaults.standardUserDefaults().objectForKey("accessTokenKey") as? String {
      self.accessToken = keyCheck
    }
    
  }
  
  //Request access token
  func requestAccessToken() {
    //
    let url = NSURL(string:"https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo,notifications")

    UIApplication.sharedApplication().openURL(url!)
  }
  
  //this method will be called within the appDelegate / 
  func handleCallbackURL(url: NSURL) {
    // this is the code recieved from github upon the initial request for access
    let code = url.query
    // get the POST url from github - 
    let baseURL = NSURL(string:"https://github.com/login/oauth/access_token?\(code!)&client_id=\(self.clientID)&client_seacret=\(self.clientSeacret)")
    let requestPOST = NSMutableURLRequest(URL: baseURL!)
    requestPOST.HTTPMethod = "POST"
    
    let dataTask = self.urlSession.dataTaskWithRequest(requestPOST, completionHandler: { (data, response, error) -> Void in
      if (error == nil) {
        if let urlResponse = response as? NSHTTPURLResponse {
          switch urlResponse.statusCode {
          case 200...299:
            println("\(urlResponse.statusCode)")
            // the data github is returning is not JSON - TODO: there is a way to request JSON
            let tokenRecieved = NSString(data: data, encoding: NSASCIIStringEncoding)
            println("\(tokenRecieved)")
            //now need to parse the response and pull out the token
            let tokenComponent = tokenRecieved?.componentsSeparatedByString("&").first as String
            let token = tokenComponent.componentsSeparatedByString("=").last
            
            //store this using NSUserDefault - in init constructor - check if this key has a value and assgin it to the accessToken
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: self.accessTokenKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
          case 300...499:
            println("\(urlResponse.statusCode)")
          case 500...599:
            println("\(urlResponse.statusCode)")
          default:
            println("default case triggered - not good")
          }
        }
      }
    })
    
    
    dataTask.resume()
  }
  
  
  
  //search repo for searchTerm - callback returns a populated array of Repo structs or an error
  func fetchRepoForSearchTerm(searchTerm:String, callback:(repo:[Repo]?, error:String?) -> (Void)) {
    //dataTask initilizes the dataTaskWithURL method in
    let url = NSURL(string: "https://reddit.com") //TODO: change this!
    
    let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      if(error == nil) { // cast response into NSHTTPURLResponse  to get source codes
        if let httpResponse = response as? NSHTTPURLResponse {
          //TODO: implement switch statement here
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
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                callback(repo: repo, error: "GTG")
                })
              }
            }
          }
        }
      })
    dataTask.resume()
  }

  
}