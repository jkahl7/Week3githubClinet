//
//  mainMenuTableViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class mainMenuTableViewController: UITableViewController
{

  var netController : NetworkController!
  
  var buttonLoop    : Bool = true
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    /*provides a centralized point of control and coordination for apps running on iOS. Every app must have exactly one instance of UIApplication (or a subclass of UIApplication). */
    // this property gives us access to the appDelegate
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //gives us access to the netController (now a singleton) initilized in the appDelegate
    self.netController = appDelegate.netController
  }
  
  override func viewDidAppear(animated: Bool)
  {
    super.viewDidAppear(animated)
    //clears out the navcontroller delegate - otherwise there will be issues w/ userSearchVC - it is a navCont delegate - will become zombie when returning to main view
    self.navigationController?.delegate = nil
    // check for accessToken, initiate oauth call if not present 
    if (self.netController.accessToken == nil)
    {
      //MARK: AlertView - when "I Dig" is clicked - launches request access token from AlertView
      let alertView = NSBundle.mainBundle().loadNibNamed("AlertView", owner: self, options: nil).first as AlertView
      alertView.alertLabel.text = "You need to sign in, ya dig?"
      alertView.center    = self.view.center // aligns the alertView within the owners(mainMenu) view
      alertView.alpha     = 0
      alertView.transform = CGAffineTransformMakeScale(0.1, 0.1) // alertView.transforms initial value
      self.view.addSubview(alertView)
      
      UIView.animateWithDuration(0.4, delay: 0.3, options: nil, animations: { () -> Void in
        alertView.alpha     = 1.0
        alertView.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }) { (finished) -> Void in
          alertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
