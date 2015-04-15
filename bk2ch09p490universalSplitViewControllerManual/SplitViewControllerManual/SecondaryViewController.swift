

import UIKit

class SecondaryViewController : UIViewController {
    
    // configure our interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        let b = UIButton.buttonWithType(.System) as! UIButton
        b.setTitle("Configure", forState: .Normal)
        b.addTarget(self, action: "callShowHide:", forControlEvents: .TouchUpInside)
        self.view.addSubview(b)
        b.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:[b]-|", options: nil, metrics: nil, views: ["b":b])
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[b]-|", options: nil, metrics: nil, views: ["b":b])
        )
    }
    
    func callShowHide(sender:AnyObject?) {
        // this intermediate method is unnecessary; it's just so I can log the call
        println("calling showHide on self")
        self.showHide(sender)
    }
}
