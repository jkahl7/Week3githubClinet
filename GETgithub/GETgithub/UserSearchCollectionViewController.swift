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
  
  var netController:NetworkController!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var imageOrigin:CGRect?
  
  override func viewDidLoad() {
   super.viewDidLoad()
   self.searchBar.delegate = self
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.navigationController?.delegate = self
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //gives us access to the netController (now a singleton) initilized in the appDelegate
    self.netController = appDelegate.netController
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
  
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

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.usersArray.count
    }
  
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
     
      let itemProperties = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
      
      self.imageOrigin = self.view.convertRect(itemProperties!.frame, fromCoordinateSpace: collectionView)
      
      let storyboard = UIStoryboard(name: "Main", bundle:nil)
      
      let toDetailVC = storyboard.instantiateViewControllerWithIdentifier("UserDetailViewController") as UserDetailViewController
      
      toDetailVC.selectedUser = self.usersArray[indexPath.row]
      
      self.navigationController?.pushViewController(toDetailVC, animated: true)
  }
  /*
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PRESENT_USER_DETAIL" {
      let toVC = segue.destinationViewController as UserDetailViewController
      let selectedIndex = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
      toVC.selectedUser = self.usersArray[selectedIndex.row]
    }
  }

*/

  
  

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCollectionViewCell
    cell.userImage.image = nil
    cell.backgroundColor = UIColor.greenColor()
    
    if(self.usersArray[indexPath.row].userAvatarImage == nil) {
      self.netController.fetchUserImage(self.usersArray[indexPath.row].userAvatarURL, index: indexPath, completionHandler: { (userImage, storedIndex, errorReport) -> (Void) in
        if(errorReport == nil) {
          self.usersArray[storedIndex].updateImage(userImage!)
          cell.userImage.image = userImage
        }
      })
    } else {
      cell.userImage.image = self.usersArray[indexPath.row].userAvatarImage
    }
    return cell
  }
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if (fromVC is UserSearchCollectionViewController) {
      return ToUserDetailnAnimationController()
    } else {
      return nil
    }
  }
  
  
  
  
  
  
  
}
