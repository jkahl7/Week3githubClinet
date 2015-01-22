//
//  mainMenuTableViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class mainMenuTableViewController: UITableViewController {

  var netController:NetworkController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    /*provides a centralized point of control and coordination for apps running on iOS. Every app must have exactly one instance of UIApplication (or a subclass of UIApplication). */
    // this property gives us access to the appDelegate
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //gives us access to the netController (now a singleton) initilized in the appDelegate
    self.netController = appDelegate.netController
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    // check for accessToken, initiate oauth call if not present 
    if (self.netController.accessToken == nil) {
      println("accessToken == nil")
      self.netController.requestAccessToken()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
