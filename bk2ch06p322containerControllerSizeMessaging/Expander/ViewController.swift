

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



// crude test example to demonstrate iOS 8 parent-child size-change messaging

class ViewController: UIViewController {
    
    var childsize = CGSize.zero
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let child = ViewControllerChild()
        self.addChild(child)
        self.view.addSubview(child.view)
        
        var sz = child.preferredContentSize
        sz.width = min(sz.width, self.view.frame.width - 40*2)
        sz.height = min(sz.height, self.view.frame.height - 40*2)
        self.childsize = sz
        
        child.view.frame = CGRect(origin: CGPoint(40,40), size: sz)
        child.view.translatesAutoresizingMaskIntoConstraints = true
        child.view.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
        
        // can't call this because we have no transition coordinator (bug?)
        // child.viewWillTransition(to: sz, with: nil)

    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        let child = self.children[0]
        if container as! UIViewController == child {
            var sz = child.preferredContentSize
            print("parent hears that the child wants to change size to \(sz)")
            sz.width = min(sz.width, self.view.frame.width - 40*2)
            sz.height = min(sz.height, self.view.frame.height - 40*2)
            
            // can't call this because we have no transition coordinator (bug?)
            // child.viewWillTransition(to: sz, with: nil)
            
            child.view.frame = CGRect(origin: CGPoint(40,40), size: sz)
            self.childsize = sz
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return self.childsize
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // are we rotating 90 degrees?
        let rot = coordinator.targetTransform
        if !(rot.b == 0 && rot.c == 0) {
            // would our subview be too big for the new orientation?
            let child = self.children[0]
            let f = child.view.frame
            print(f)
            let f2 = self.view.bounds
            if f.origin.x + f.width > f2.height || f.origin.y + f.height > f2.width {
                (self.childsize.width, self.childsize.height) = (self.childsize.height, self.childsize.width)
                child.view.frame = CGRect(origin: CGPoint(40,40), size:self.childsize)
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }


}

