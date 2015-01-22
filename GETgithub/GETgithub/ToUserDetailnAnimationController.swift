//
//  ToUserDetailnAnimationController.swift
//  GETgithub
//
//  Created by Josh Kahl on 1/21/15.
//  Copyright (c) 2015 Josh Kahl. All rights reserved.
//

import UIKit

class ToUserDetailnAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
 // var origin: CGRect?
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 1.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    // Find references for the two views controllers we're moving between
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchCollectionViewController
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    // Grab the container view from the context
    let containerView = transitionContext.containerView()
    
    // Position the toViewController in it's starting position
    toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
    toViewController.imageView.frame = toViewController.view.bounds
    
    // Add the toViewController's view onto the containerView
    containerView.addSubview(toViewController.view)
    
    UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: { () -> Void in
      // During animation, expand the toViewController's view frame
      // to match the original view controllers
      // This will cause the toViewController to fill the screen
      toViewController.view.frame = fromViewController.view.frame
      toViewController.imageView.frame = fromViewController.view.bounds
      }) { (finished) -> Void in
        // When finished, hide our fromViewController
        fromViewController.view.alpha = 0.0
        // And tell the transitionContext we're done
        transitionContext.completeTransition(finished)
      
    }
  }
}
  
  /*
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.4
  }
  // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserSearchCollectionViewController
    
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    let containerView = transitionContext.containerView()
    
    // make a copy/snapshot of the selected cell's imageView 
  
    
    let fromIndexPath = fromViewController.collectionView.indexPathsForSelectedItems().first as NSIndexPath
    
    let cell = fromViewController.collectionView.cellForItemAtIndexPath(fromIndexPath) as UserCollectionViewCell

    let copyOfCell = cell.userImage.snapshotViewAfterScreenUpdates(false)
    
    cell.userImage.hidden = true
    
    copyOfCell.frame = containerView.convertRect(cell.userImage.frame, fromView: cell.userImage.superview)
    
    toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
    
    toViewController.view.alpha = 0
    toViewController.imageView.hidden = true
    
    
    containerView.addSubview(toViewController.view)
    containerView.addSubview(copyOfCell)
    
    toViewController.view.setNeedsLayout()
    toViewController.view.layoutIfNeeded()
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toViewController.view.alpha = 1.0
      
      let frame = containerView.convertRect(toViewController.imageView.frame, fromCoordinateSpace: toViewController.view)
      
      
      }) { (finished) -> Void in
        
        toViewController.imageView.hidden = false
        cell.userImage.hidden = false
        copyOfCell.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
    
  }

  
} */
