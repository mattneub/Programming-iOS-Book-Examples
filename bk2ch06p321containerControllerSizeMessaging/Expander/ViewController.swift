

import UIKit

// crude test example to demonstrate iOS 8 parent-child size-change messaging

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let child = ViewControllerChild()
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        
        var sz = child.preferredContentSize
        sz.width = min(sz.width, self.view.frame.width - 40*2)
        sz.height = min(sz.height, self.view.frame.height - 40*2)
        
        
        child.view.frame = CGRect(origin: CGPointMake(40,40), size: sz)
        child.view.setTranslatesAutoresizingMaskIntoConstraints(true)
        child.view.autoresizingMask = .FlexibleBottomMargin | .FlexibleRightMargin
        
        // notification of child is _manual_
        child.viewWillTransitionToSize(sz, withTransitionCoordinator: nil)

    }
    
    override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer!) {
        let child = self.childViewControllers[0] as UIViewController
        if container as UIViewController == child {
            var sz = child.preferredContentSize
            sz.width = min(sz.width, self.view.frame.width - 40*2)
            sz.height = min(sz.height, self.view.frame.height - 40*2)
            child.view.frame = CGRect(origin: CGPointMake(40,40), size: sz)
            // notification of child is _manual_
            child.viewWillTransitionToSize(sz, withTransitionCoordinator: nil)
        }

    }
    
    // we seriously should override this method, becaues if we don't...
    // ...the default behavior is to pass the _same_ size to the child, which is nutty
    // comment out this method and rotate the app, to see what the problem is
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
        // manually block default behavior, tell child nothing because nothing will change
        // in real life, we might actually change the child view size to fit the interface...
        // ...and tell the child about it (and in this case we will have a tc)
    }


}

