
import UIKit

class ViewController : Base {
    
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    let which = 2 // 1 means automatic appearance forwarding, 2 means manual, try both
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
        
        self.swappers.append(self.childViewControllers[0])
        self.swappers.append(self.storyboard!.instantiateViewControllerWithIdentifier("child2"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if which == 2 {
            print("Forwarding manually!")
            let child = self.swappers[self.cur] 
            if child.isViewLoaded() && child.view.superview != nil {
                child.beginAppearanceTransition(true, animated: true)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] 
            if child.isViewLoaded() && child.view.superview != nil {
                child.endAppearanceTransition()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] 
            if child.isViewLoaded() && child.view.superview != nil {
                child.beginAppearanceTransition(false, animated: true)
            }
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] 
            if child.isViewLoaded() && child.view.superview != nil {
                child.endAppearanceTransition()
            }
        }
    }

    

    
/*
    
On startup we expect to see (ignoring parent messages):

    ChildViewController1 willMoveToParentViewController ViewController
    ChildViewController1 didMoveToParentViewController ViewController
    ChildViewController1 viewWillAppear
    ChildViewController1 updateViewConstraints()
    ChildViewController1 viewWillLayoutSubviews()
    ChildViewController1 viewDidLayoutSubviews()
    ChildViewController1 viewDidAppear
    
*/
    
    
/*

On flip we expect to see (ignoring parent messages):

    ChildViewController2 willMoveToParentViewController ViewController
    ChildViewController1 willMoveToParentViewController nil
    ChildViewController1 viewWillDisappear
    ChildViewController2 viewWillAppear
    ChildViewController2 updateViewConstraints()
    ChildViewController2 viewWillLayoutSubviews()
    ChildViewController2 viewDidLayoutSubviews()
    ChildViewController2 viewDidAppear
    ChildViewController1 viewDidDisappear
    ChildViewController2 didMoveToParentViewController ViewController
    ChildViewController1 didMoveToParentViewController nil

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
    Thus these, by calling super or not, are the equivalent
    of shouldAutomaticallyForwardRotationMethods and then forwarding or not
    
    ViewController willTransitionToTraitCollection(_:withTransitionCoordinator:)
    ChildViewController1 willTransitionToTraitCollection(_:withTransitionCoordinator:)
    ViewController viewWillTransitionToSize(_:withTransitionCoordinator:)
    ChildViewController1 viewWillTransitionToSize(_:withTransitionCoordinator:)
    
    ViewController updateViewConstraints()
    ViewController viewWillLayoutSubviews()
    ViewController viewDidLayoutSubviews()
    
    // not getting these, though my notes say we used to:
<ChildViewController1: 0x7b78c880> viewWillLayoutSubviews()
<ChildViewController1: 0x7b78c880> viewDidLayoutSubviews()
    
*/

    
}
