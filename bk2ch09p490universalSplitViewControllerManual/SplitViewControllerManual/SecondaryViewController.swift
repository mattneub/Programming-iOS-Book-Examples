

import UIKit

class SecondaryViewController : UIViewController {
    
    // configure our interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        let b = UIButton(type:.System)
        b.setTitle("Configure", forState: .Normal)
        b.backgroundColor = UIColor.yellowColor()
        b.addTarget(self, action: "callShowHide:", forControlEvents: .TouchUpInside)
        self.view.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("H:[b]-|", options: [], metrics: nil, views: ["b":b]),
            NSLayoutConstraint.constraintsWithVisualFormat("V:[b]-|", options: [], metrics: nil, views: ["b":b])
            ].flatten().map{$0})
    }
    
    func callShowHide(sender:AnyObject?) {
        // this intermediate method is unnecessary; it's just so I can log the call
        print("calling showHide on self")
        self.showHide(sender)
    }
}
