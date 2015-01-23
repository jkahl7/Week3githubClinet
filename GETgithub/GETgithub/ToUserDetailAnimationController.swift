//
//  ToUserDetailAnimationController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/21/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class ToUserDetailAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 1.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    // Find references for the two views controllers we're moving between
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchCollectionViewController
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    // Grab the container view from the context
    let containerView = transitionContext.containerView()
    
    //make a copy of the cell
    let fromIndexPath = fromViewController.collectionView.indexPathsForSelectedItems().first as NSIndexPath
    
    let cell = fromViewController.collectionView.cellForItemAtIndexPath(fromIndexPath) as UserCollectionViewCell
    
    //Returns a snapshot view based on the contents of the current view.
    let copyOfCell = cell.imageView.snapshotViewAfterScreenUpdates(false)
    
    cell.imageView.hidden = true
    
    copyOfCell.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
    
    toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
    
    toViewController.view.alpha = 0
    toViewController.imageView.hidden = true
    
    /******** THIS IS DIFFERENT  *********/
    // Position the toViewController in it's starting position
    toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
    toViewController.imageView.frame = toViewController.view.bounds
    
    // Add the toViewController's view onto the containerView
    containerView.addSubview(toViewController.view)
    containerView.addSubview(copyOfCell)
    
    toViewController.view.setNeedsLayout()
    toViewController.view.layoutIfNeeded()
    
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toViewController.view.alpha = 1.0
      
      let frame = containerView.convertRect(toViewController.imageView.frame, fromView: toViewController.view)
    }) { (finished) -> Void in
      
      toViewController.imageView.hidden = false
      cell.imageView.hidden = false
      fromViewController.view.alpha = 0.0
      copyOfCell.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
  }
}
