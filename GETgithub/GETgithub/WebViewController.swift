//
//  WebViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/22/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate
{
  @IBOutlet weak var webView  : UIWebView!
  
  //pass the selected Repo object to this VC
  var repo  : Repo!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.webView.delegate = self
    
    println(self.repo.userRepoURL)
    println(self.repo.userName)
    println(self.repo.language)
    
    if(self.repo.userRepoURL != nil)
    {
      println(self.repo.userRepoURL)
      let request = NSURLRequest(URL: NSURL(string: self.repo.userRepoURL!)!)
      self.webView.loadRequest(request)
    } else {  // send their ass to reddit.
      let url     = NSURL(string: "http://www.m.reddit.com")
      let request = NSURLRequest(URL: url!)
      self.webView.loadRequest(request)
    }
  }
  
    override func didReceiveMemoryWarning()
    {
      super.didReceiveMemoryWarning()
    }
}
