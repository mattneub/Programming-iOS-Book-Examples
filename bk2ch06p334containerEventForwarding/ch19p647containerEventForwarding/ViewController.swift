
import UIKit

class ViewController : Base {
    
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    let which = 1 // 1 means automatic appearance forwarding, 2 means manual, try both
    // you will see that the messages to the child are the same either way,
    // thus proving we're doing manual forwarding correctly
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        var result = true
        if which == 2 {
            result = false
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.swappers.append(self.childViewControllers[0] as! UIViewController)
        self.swappers.append(self.storyboard!.instantiateViewControllerWithIdentifier("child2") as! UIViewController)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if which == 2 {
            println("Forwarding manually!")
            let child = self.swappers[self.cur] as UIViewController
            if child.isViewLoaded() && child.view.superview != nil {
                child.beginAppearanceTransition(true, animated: true)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] as UIViewController
            if child.isViewLoaded() && child.view.superview != nil {
                child.endAppearanceTransition()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] as UIViewController
            if child.isViewLoaded() && child.view.superview != nil {
                child.beginAppearanceTransition(false, animated: true)
            }
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] as UIViewController
            if child.isViewLoaded() && child.view.superview != nil {
                child.endAppearanceTransition()
            }
        }
    }

    

    
/*
    
On startup we expect to see (ignoring parent messages):

<ChildViewController1: 0x79180d50> willMoveToParentViewController <ViewController: 0x79179420>
<ChildViewController1: 0x79180d50> didMoveToParentViewController <ViewController: 0x79179420>
<ChildViewController1: 0x79180d50> viewWillAppear
<ChildViewController1: 0x79180d50> updateViewConstraints()
<ChildViewController1: 0x79180d50> viewWillLayoutSubviews()
<ChildViewController1: 0x79180d50> viewDidLayoutSubviews()
<ChildViewController1: 0x79180d50> viewDidAppear
    
*/
    
    
/*

On flip we expect to see (ignoring parent messages):

<ChildViewController2: 0x79183f80> willMoveToParentViewController <ViewController: 0x79179420>
<ChildViewController1: 0x79180d50> willMoveToParentViewController nil
<ChildViewController1: 0x79180d50> viewWillDisappear
<ChildViewController2: 0x79183f80> viewWillAppear
<ChildViewController2: 0x79183f80> updateViewConstraints()
<ChildViewController2: 0x79183f80> viewWillLayoutSubviews()
<ChildViewController2: 0x79183f80> viewDidLayoutSubviews()
<ChildViewController2: 0x79183f80> viewDidAppear
<ChildViewController1: 0x79180d50> viewDidDisappear
<ChildViewController2: 0x79183f80> didMoveToParentViewController <ViewController: 0x79179420>
<ChildViewController1: 0x79180d50> didMoveToParentViewController nil

*/

    
    @IBAction func doFlip(sender:AnyObject?) {
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        
        tovc.view.frame = fromvc.view.superview!.bounds
        
        // must have both as children before we can transition between them
        self.addChildViewController(tovc) // "will" called for us
        // note: when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMoveToParentViewController(nil)
        
        switch which {
        case 1: // normal
            self.transitionFromViewController(fromvc,
                toViewController:tovc,
                duration:0.4,
                options:.TransitionFlipFromLeft,
                animations:nil,
                completion:{
                    _ in
                    // finally, finish up
                    // note: when we call add, we must call "did" afterwards
                    tovc.didMoveToParentViewController(self)
                    fromvc.removeFromParentViewController() // "did" called for us
                })
        case 2: // manual forwarding of appearance messages
            fromvc.beginAppearanceTransition(false, animated:true) // *
            tovc.beginAppearanceTransition(true, animated:true) // *
            
            // then perform the transition
            // we cannot call transitionFromViewController:toViewController:!
            // it tries to manage begin/end appearance itself ("legacy")
            // we just perform an ordinary transition
            
            UIView.transitionFromView(fromvc.view,
                toView:tovc.view,
                duration:0.4,
                options:.TransitionFlipFromLeft,
                completion:{
                    _ in
                    tovc.endAppearanceTransition() // *
                    fromvc.endAppearanceTransition() // *
                    
                    // note: when we call add, we must call "did" afterwards
                    tovc.didMoveToParentViewController(self)
                    fromvc.removeFromParentViewController() // "did" called for us
                })
        default: break
        }

        
    }
    
/*
Another interesting set of messages is on rotation:
    
NB The child is messaged on the first two _because_ the parent calls super
    Thus these, by calling super or not, are the iOS 8 version
    of shouldAutomaticallyForwardRotationMethods and then forwarding or not
    
<ViewController: 0x7b786570> willTransitionToTraitCollection(_:withTransitionCoordinator:)
<ChildViewController1: 0x7b78c880> willTransitionToTraitCollection(_:withTransitionCoordinator:)
<ViewController: 0x7b786570> viewWillTransitionToSize(_:withTransitionCoordinator:)
<ChildViewController1: 0x7b78c880> viewWillTransitionToSize(_:withTransitionCoordinator:)
[and also]
<ViewController: 0x7b786570> viewWillLayoutSubviews()
<ViewController: 0x7b786570> updateViewConstraints()
<ViewController: 0x7b786570> viewDidLayoutSubviews()
<ChildViewController1: 0x7b78c880> viewWillLayoutSubviews()
<ChildViewController1: 0x7b78c880> viewDidLayoutSubviews()
    
*/

    
}
