

import UIKit

// crude test example to demonstrate iOS 8 parent-child size-change messaging

class ViewController: UIViewController {
    
    var childsize = CGSizeZero
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let child = ViewControllerChild()
        self.addChildViewController(child)
        self.view.addSubview(child.view)
        
        var sz = child.preferredContentSize
        sz.width = min(sz.width, self.view.frame.width - 40*2)
        sz.height = min(sz.height, self.view.frame.height - 40*2)
        self.childsize = sz
        
        child.view.frame = CGRect(origin: CGPointMake(40,40), size: sz)
        child.view.translatesAutoresizingMaskIntoConstraints = true
        child.view.autoresizingMask = [.FlexibleBottomMargin, .FlexibleRightMargin]
        
        // can't call this because we have no transition coordinator (bug?)
        // child.viewWillTransitionToSize(sz, withTransitionCoordinator: nil)

    }
    
    override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        let child = self.childViewControllers[0]
        if container as! UIViewController == child {
            var sz = child.preferredContentSize
            print("parent hears that the child wants to change size to \(sz)")
            sz.width = min(sz.width, self.view.frame.width - 40*2)
            sz.height = min(sz.height, self.view.frame.height - 40*2)
            
            // can't call this because we have no transition coordinator (bug?)
            // child.viewWillTransitionToSize(sz, withTransitionCoordinator: nil)
            
            child.view.frame = CGRect(origin: CGPointMake(40,40), size: sz)
            self.childsize = sz
        }
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return self.childsize
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // are we rotating 90 degrees?
        let rot = coordinator.targetTransform()
        if !(rot.b == 0 && rot.c == 0) {
            // would our subview be too big for the new orientation?
            let child = self.childViewControllers[0]
            let f = child.view.frame
            print(f)
            let f2 = self.view.bounds
            if f.origin.x + f.width > f2.height || f.origin.y + f.height > f2.width {
                (self.childsize.width, self.childsize.height) = (self.childsize.height, self.childsize.width)
                child.view.frame = CGRect(origin: CGPointMake(40,40), size:self.childsize)
            }
        }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }


}

