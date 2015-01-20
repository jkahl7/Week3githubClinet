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
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var tableView: UITableView!
  
  let netController = NetController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.estimatedRowHeight = 144
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.tableView.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
    
    self.netController.fetchRepoForSearchTerm("TODO:connect to searchBar", callback: { (repo, error) -> (Void) in
      if(error != nil) {
        self.repoArray = repo!
        self.tableView.reloadData()
      }
    })
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repoArray.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as RepoCell
    let myRepo = self.repoArray[indexPath.row]
    
    
    cell.userName.text = myRepo.userName
    cell.repoContent.text = myRepo.userRepo
    cell.language.text = "Language:" + myRepo.language
    
    //lazy load user avatar
    
    
    return cell
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) { // called when keyboard search button pressed
    searchBar.resignFirstResponder()
    println("\(self.searchBar.text)")
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
