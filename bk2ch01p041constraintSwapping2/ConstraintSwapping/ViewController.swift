

import UIKit

class ViewController: UIViewController {
    var v1 : UIView!
    var v2 : UIView!
    var v3 : UIView!
    var constraintsWith = [NSLayoutConstraint]()
    var constraintsWithout = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainview = self.view
        
        let v1 = UIView()
        v1.backgroundColor = UIColor.redColor()
        v1.translatesAutoresizingMaskIntoConstraints = false
        let v2 = UIView()
        v2.backgroundColor = UIColor.yellowColor()
        v2.translatesAutoresizingMaskIntoConstraints = false
        let v3 = UIView()
        v3.backgroundColor = UIColor.blueColor()
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(v1)
        mainview.addSubview(v2)
        mainview.addSubview(v3)
        
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        
        let c1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v":v1])
        let c2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v":v2])
        let c3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v":v3])
        let c4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(100)-[v(20)]", options: [], metrics: nil, views: ["v":v1])
        let c5with = NSLayoutConstraint.constraintsWithVisualFormat("V:[v1]-(20)-[v2(20)]-(20)-[v3(20)]", options: [], metrics: nil, views: ["v1":v1, "v2":v2, "v3":v3])
        let c5without = NSLayoutConstraint.constraintsWithVisualFormat("V:[v1]-(20)-[v3(20)]", options: [], metrics: nil, views: ["v1":v1, "v3":v3])
        self.constraintsWith.appendContentsOf(c1)
        self.constraintsWith.appendContentsOf(c2)
        self.constraintsWith.appendContentsOf(c3)
        self.constraintsWith.appendContentsOf(c4)
        self.constraintsWith.appendContentsOf(c5with)
        
        self.constraintsWithout.appendContentsOf(c1)
        self.constraintsWithout.appendContentsOf(c3)
        self.constraintsWithout.appendContentsOf(c4)
        self.constraintsWithout.appendContentsOf(c5without)
        
        NSLayoutConstraint.activateConstraints(self.constraintsWith)
    }
    
    func doSwap() {
        let mainview = self.view
        if self.v2.superview != nil {
            self.v2.removeFromSuperview()
            NSLayoutConstraint.deactivateConstraints(self.constraintsWith)
            NSLayoutConstraint.activateConstraints(self.constraintsWithout)
        } else {
            mainview.addSubview(v2)
            NSLayoutConstraint.deactivateConstraints(self.constraintsWithout)
            NSLayoutConstraint.activateConstraints(self.constraintsWith)
        }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        let prev = previousTraitCollection
        let tc = self.traitCollection
        if prev == nil && tc.verticalSizeClass == .Compact {
            self.doSwap()
        } else if prev != nil && tc.verticalSizeClass != prev!.verticalSizeClass {
            self.doSwap()
        }
    }
}

