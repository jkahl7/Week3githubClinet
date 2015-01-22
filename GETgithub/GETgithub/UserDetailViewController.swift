//
//  UserDetailViewController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/21/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

  // after selecting a collectionView Cell in userSearch Collection view, this screen will be displayed with the users image & information
  
  var selectedUser:User?
  
  @IBOutlet weak var imageView: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let image = self.selectedUser?.userAvatarImage {
      self.imageView.image = image
    }
    
    println("transition to detail complete")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
