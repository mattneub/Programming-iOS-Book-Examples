

import UIKit

class SecondaryViewController : UIViewController {
    
    // configure our interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        let b = UIButton.buttonWithType(.System) as UIButton
        b.setTitle("Configure", forState: .Normal)
        b.addTarget(self, action: "showHidePrimary:", forControlEvents: .TouchUpInside)
        self.view.addSubview(b)
        b.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:[b]-|", options: nil, metrics: nil, views: ["b":b])
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[b]-|", options: nil, metrics: nil, views: ["b":b])
        )
    }
    
    // communicate with the Primary to appear or disappear
    func showHidePrimary(sender:AnyObject) {
        // how to use targetViewControllerForAction to look up the hierarchy
        // we don't know who implements showHide or where he is in the hierarchy,
        // and we don't care! agnostic messaging up the hierarchy
        let target = self.targetViewControllerForAction("showHide:", sender: self)
        if target != nil {
            target!.showHide(self)
        }
    }
    
}
