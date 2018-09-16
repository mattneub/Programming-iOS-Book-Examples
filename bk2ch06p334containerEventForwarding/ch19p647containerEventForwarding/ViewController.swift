
import UIKit

class ViewController : Base {
    
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    let which = 2 // 1 means automatic appearance forwarding, 2 means manual, try both
    // you will see that the messages to the child are the same either way,
    // thus proving we're doing manual forwarding correctly
    
    override var shouldAutomaticallyForwardAppearanceMethods : Bool {
        var result = true
        if which == 2 {
            result = false
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.swappers.append(self.children[0])
        self.swappers.append(self.storyboard!.instantiateViewController(withIdentifier: "child2"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if which == 2 {
            print("Forwarding manually!")
            let child = self.swappers[self.cur] 
            if child.isViewLoaded && child.view.superview != nil {
                child.beginAppearanceTransition(true, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] 
            if child.isViewLoaded && child.view.superview != nil {
                child.endAppearanceTransition()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] 
            if child.isViewLoaded && child.view.superview != nil {
                child.beginAppearanceTransition(false, animated: true)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if which == 2 {
            let child = self.swappers[self.cur] 
            if child.isViewLoaded && child.view.superview != nil {
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

    
    @IBAction func doFlip(_ sender: Any?) {
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        
        tovc.view.frame = fromvc.view.superview!.bounds
        
        // must have both as children before we can transition between them
        self.addChild(tovc) // "will" called for us
        // when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParent: nil)
        
        switch which {
        case 1: // normal
            self.transition(from: fromvc,
                            to:tovc,
                            duration:0.4,
                            options:.transitionFlipFromLeft,
                            animations:nil,
                            completion:{
                                _ in
                                // finally, finish up
                                // note: when we call add, we must call "did" afterwards
                                tovc.didMove(toParent: self)
                                fromvc.removeFromParent() // "did" called for us
            })
        case 2: // manual forwarding of appearance messages
            fromvc.beginAppearanceTransition(false, animated:true) // *
            tovc.beginAppearanceTransition(true, animated:true) // *
            
            // then perform the transition
            // we cannot call transitionFromViewController:toViewController:!
            // it tries to manage begin/end appearance itself ("legacy")
            // we just perform an ordinary transition
            
            UIView.transition(
                from:fromvc.view, to:tovc.view,
                duration:0.4, options:.transitionFlipFromLeft) {_ in
                    tovc.endAppearanceTransition() // *
                    fromvc.endAppearanceTransition() // *
                    
                    // when we call add, we must call "did" afterwards
                    tovc.didMove(toParent: self)
                    fromvc.removeFromParent() // "did" called for us
            }
        default: break
        }
        
        
    }
    
/*
Another interesting set of messages is on rotation:
    
NB The child is messaged on the first two _because_ the parent calls super
    Thus these, by calling super or not, are the equivalent
    of shouldAutomaticallyForwardRotationMethods and then forwarding or not
    
    ViewController willTransition(to: _:withTransitionCoordinator:)
    ChildViewController1 willTransition(to: _:withTransitionCoordinator:)
    ViewController viewWillTransition(to: _:withTransitionCoordinator:)
    ChildViewController1 viewWillTransition(to: _:withTransitionCoordinator:)
    
    ViewController updateViewConstraints()
    ViewController viewWillLayoutSubviews()
    ViewController viewDidLayoutSubviews()
    
    // not getting these, though my notes say we used to:
<ChildViewController1: 0x7b78c880> viewWillLayoutSubviews()
<ChildViewController1: 0x7b78c880> viewDidLayoutSubviews()
    
*/

    
}
