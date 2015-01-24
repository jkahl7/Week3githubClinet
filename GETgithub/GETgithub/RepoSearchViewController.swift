//
//  RepoSearchViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/19/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

  var repoArray = [Repo]()
  
  var netController : NetworkController!
  
  @IBOutlet weak var activityIndicator  : UIActivityIndicatorView!
  @IBOutlet weak var searchBar          : UISearchBar!
  @IBOutlet weak var tableView          : UITableView!
 /*
  Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
  The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKit/UIView.h> may also be helpful.
  */
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.estimatedRowHeight = 144
    self.tableView.rowHeight          = UITableViewAutomaticDimension
    self.tableView.delegate           = self
    self.tableView.dataSource         = self
    self.tableView.hidden             = true
    self.searchBar.delegate           = self
    self.activityIndicator.hidden     = true
    
    self.tableView.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //gives us access to the netController (now a singleton) initilized in the appDelegate
    self.netController = appDelegate.netController
    
    }
  
  /*********************************************************************************************
  ***                           MARK:  tableView Methods                                     ***
  *********************************************************************************************/

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    //check that userRepoURL is valid and launch WebViewController
    let repoToWebView = self.repoArray[indexPath.row]
    //maybe check the status code of this website??
    
    let toVC  = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
    toVC.repo = repoToWebView
    
    self.navigationController?.pushViewController(toVC, animated: true)
  }
  

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.repoArray.count
  }


  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell   = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as RepoCell
    let myRepo = self.repoArray[indexPath.row]
    
    cell.userName.text         = myRepo.userName
    cell.repoContent.text      = myRepo.userRepo
    cell.backgroundImage.backgroundColor = UIColor.grayColor()
    
    if myRepo.language != nil
    {
      cell.language.text = "Language:" + myRepo.language!
    }
    
    cell.alpha     = 0.0
    cell.transform = CGAffineTransformMakeScale(0.1, 0.5) // alertView.transforms initial value
    
    UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: { () -> Void in
      cell.alpha     = 0.75
      cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        cell.alpha   = 1.0
    }
    return cell
  }
  
  /*********************************************************************************************
  ***                           MARK:  searchBarMethods                                      ***
  *********************************************************************************************/
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
  {
    if (text.repoNameSearchValidation() == false)
    {
      println("not a valid character")
      return false
    } else {
      return true
    }
  }
  
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar)
  {
    self.activityIndicator.hidden = false
    
    self.activityIndicator.startAnimating()
    self.searchBar.resignFirstResponder()
    //called when keyboard search button pressed
    self.netController.fetchRepoForSearchTerm(self.searchBar.text, callback: { (repo, error) -> (Void) in
      println(searchBar.text)
      if(error ==  nil)
      {
        self.repoArray                = repo!
        self.tableView.hidden         = false
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
      }
    })
  }
  
  
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
