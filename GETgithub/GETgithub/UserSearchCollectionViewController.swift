//
//  UserSearchCollectionViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/21/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class UserSearchCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {

  var usersArray = Array<User>()
  
  var imageDictionary = [String:UIImage]()
  
  var netController:NetworkController!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var imageOrigin:CGRect?
  
  var selectedIndexPaths:NSIndexPath?
  
  override func viewDidLoad() {
   super.viewDidLoad()
   self.collectionView.reloadData()
    self.searchBar.delegate = self
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    // will become a zombie when we return to main view - need to clear this out
    self.navigationController?.delegate = self
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //gives us access to the netController (now a singleton) initilized in the appDelegate
    self.netController = appDelegate.netController
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.collectionView.reloadData()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  /*********************************************************************************************
  ***                           MARK:  CollectionView Methods                                ***
  *********************************************************************************************/

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.usersArray.count
    }
  /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
     
      let itemProperties = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
      self.imageOrigin = self.view.convertRect(itemProperties!.frame, fromCoordinateSpace: collectionView)
      
      let storyboard = UIStoryboard(name: "Main", bundle:nil)
      let toDetailVC = storyboard.instantiateViewControllerWithIdentifier("UserDetailViewController") as UserDetailViewController
      toDetailVC.selectedUser = self.usersArray[indexPath.row]
      self.navigationController?.pushViewController(toDetailVC, animated: true)
  }
  */
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCollectionViewCell
    cell.imageView.image = nil
    cell.backgroundColor = UIColor.greenColor()
    
    if(self.usersArray[indexPath.row].userAvatarImage == nil) {
      self.netController.fetchUserImage(self.usersArray[indexPath.row].userAvatarURL, index: indexPath, completionHandler: { (userImage, storedIndex, errorReport) -> (Void) in
        if(errorReport == nil) {
          self.usersArray[storedIndex].updateImage(userImage!)
          cell.imageView.image = userImage
        }
      })
    } else {
      cell.imageView.image = self.usersArray[indexPath.row].userAvatarImage
    }
    return cell
  }
  
  /*********************************************************************************************
  ***                           MARK:  Segue + Navigation                                    ***
  *********************************************************************************************/
  
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if let homeViewController = fromVC as? UserSearchCollectionViewController {
      if let detailViewController = toVC as? UserDetailViewController {
        let toAnimatorVC = ToUserDetailAnimationController()
        
        return toAnimatorVC
      }
    } else {
      return nil
    }
    self.navigationController?.delegate = nil
    return nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PRESENT_USER_DETAIL" {
      let toVC = segue.destinationViewController as UserDetailViewController
      let selectedIndex = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
      toVC.selectedUser = self.usersArray[selectedIndex.row]
    }
  }
  
  /*********************************************************************************************
  ***                           MARK:  searchBarMethods                                      ***
  *********************************************************************************************/
  
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    //TODO: add an alert here
    
    
    if (text.alphaNumOnlyValidation() == false) {
      println("not a valid character")
      return false
    } else {
      return true
    }
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    // fetch userSearch info in the netVC
    self.netController.fetchUserInfo(searchBar.text, callback: { (user, error) -> (Void) in
      if(error == nil) {
        self.usersArray = user!
        self.collectionView.reloadData()
        self.searchBar.resignFirstResponder()
      }
      println(error)
    })
  }
  
  
  
  
  
}
