//
//  NetController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class NetworkController
{
  class var sharedNetworkController:NetworkController
  {
    struct Static
    {
      static let instance:NetworkController = NetworkController()
    }
    return Static.instance
  }

  var urlSession  : NSURLSession
  var accessToken : String?
  
  let imageQueue     = NSOperationQueue()
  let clientID       = "e3ecc12cc38533806169"
  let clientSecret   = "60394bb88b65cf8df87088c6556b604ca5c4cf46"
  let accessTokenKey = "accessTokenKey"
  
  init ()
  {
    //Returns a session configuration that uses no persistent storage for caches, cookies, or credentials.
    let ephemeralConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfiguration)
    
    if let keyCheck = NSUserDefaults.standardUserDefaults().objectForKey("accessTokenKey") as? String
    {
      self.accessToken = keyCheck
    }
  }
  
  /*********************************************************************************************
  ***                               MARK: requestAccessToken                                 ***
  *********************************************************************************************/

  func requestAccessToken()
  {
    let url = NSURL(string:"https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo,notifications")
    UIApplication.sharedApplication().openURL(url!)
  }
  
  /*********************************************************************************************
  ***                               MARK: handleCallbackURL                                  ***
  *********************************************************************************************/
  
  //this method will be called within the appDelegate / 
  func handleCallbackURL(url: NSURL)
  {
    // this is the code recieved from github upon the initial request for access
    let code = url.query
    // get the POST url from github - 
    let baseURL = NSURL(string:"https://github.com/login/oauth/access_token?\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)")
    let requestPOST = NSMutableURLRequest(URL: baseURL!)
    requestPOST.HTTPMethod = "POST"
    let dataTask = self.urlSession.dataTaskWithRequest(requestPOST, completionHandler: { (data, response, error) -> Void in
      if (error == nil)
      {
        if let urlResponse = response as? NSHTTPURLResponse
        {
          switch urlResponse.statusCode
          {
          case 200...299:
            println("\(urlResponse.statusCode)")
            // the data github is returning is not JSON - TODO: there is a way to request JSON
            let tokenRecieved  = NSString(data: data, encoding: NSASCIIStringEncoding)
            //now need to parse the response and pull out the token
            let tokenComponent = tokenRecieved?.componentsSeparatedByString("&").first as String
            let token          = tokenComponent.componentsSeparatedByString("=").last
            
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
  
  /*********************************************************************************************
  ***                               MARK: RepoForSearchTerm                                  ***
  *********************************************************************************************/
  
  //search repo for searchTerm - callback returns a populated array of Repo structs or an error
  func fetchRepoForSearchTerm(searchTerm:String?, callback:(repo:[Repo]?, error:String?) -> (Void))
  {
    //dataTask initilizes the dataTaskWithURL method in
    if let formatedSearchRequest = searchTerm?.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    {
      let url = NSURL(string: "https://api.github.com/search/repositories?q=\(formatedSearchRequest)")
      let urlRequest = NSMutableURLRequest(URL: url!)
      urlRequest.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
      let dataTask = self.urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
        if(error == nil) // cast response into NSHTTPURLResponse  to get source codes
        {
          if let urlResponse = response as? NSHTTPURLResponse
          {
            switch urlResponse.statusCode
            {
            case 200...299:
              var error : NSError?
              if let rawJSONData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String:AnyObject]
              {
                if(error == nil)
                {
                  var repo = [Repo]()
                  if let totalCount = rawJSONData["total_count"] as? Int
                  {
                    if let jsonArray = rawJSONData["items"] as? [[String:AnyObject]]
                    {
                      for item in jsonArray
                      {
                        let info = Repo(jsonDictionary: item, totalCount: totalCount)
                        repo.append(info)
                      }
                      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        callback(repo: repo, error: nil)
                      })
                    }
                  }
                }
              }
            case 300...599:
              println("\(urlResponse.statusCode)")
            default:
              println("\(urlResponse.statusCode)")
            }
          }
        }
      })
      dataTask.resume()
    }
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      callback(repo: nil, error: "")
    }
  }
  
  /*********************************************************************************************
  ***                           MARK:  UserInfo                                              ***
  *********************************************************************************************/
  
  func fetchUserInfo(userName:String?, callback:(user:[User]?, error:String?) -> (Void))
  {
    
    // checks if userName is not empty - i think - and removes any spaces - maybe......
   if let userString = userName?.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
   {
      //get api location url from github  /search/users
      let userSearchUrl = NSURL(string:"https://api.github.com/search/users?q=\(userString)")
      let urlRequest    = NSMutableURLRequest(URL: userSearchUrl!)
      urlRequest.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
      let dataTask = self.urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
        if(error == nil)
        {
          if let urlResponse = response as? NSHTTPURLResponse
          {
            switch urlResponse.statusCode
            {
            case 200...299:
              var error:NSError?
              if let rawJSONData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String:AnyObject]
              {
                if (error == nil)
                {
                  var users = [User]()
                  if let jsonDictionary = rawJSONData["items"] as? [[String:AnyObject]]
                  {
                    for dictionary in jsonDictionary
                    {
                      let info = User(jsonDictionary: dictionary)
                      users.append(info)
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                      callback(user: users, error: nil)
                    })
                  }
                  
                }
              }
            default:
              println("\(urlResponse.statusCode)")
            }
          }
        }
      })
    dataTask.resume()
    }
  }
  
  
  /*********************************************************************************************
  ***                           MARK:  UserImageFetch                                        ***
  *********************************************************************************************/
  
  func fetchUserImage(userImageURL:NSURL, index:NSIndexPath, completionHandler: (userImage:UIImage?, storedIndex: Int, errorReport:String?) -> (Void))
  {
    self.imageQueue.addOperationWithBlock { () -> Void in
      
      let imageData   = NSData(contentsOfURL: userImageURL)!
      let image       = UIImage(data: imageData)
      let indexKeeper = index.row
      
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(userImage: image, storedIndex: indexKeeper, errorReport: nil)
      })
    }
  }
}