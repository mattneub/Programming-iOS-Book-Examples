

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
        v1.setTranslatesAutoresizingMaskIntoConstraints(false)
        let v2 = UIView()
        v2.backgroundColor = UIColor.yellowColor()
        v2.setTranslatesAutoresizingMaskIntoConstraints(false)
        let v3 = UIView()
        v3.backgroundColor = UIColor.blueColor()
        v3.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        mainview.addSubview(v1)
        mainview.addSubview(v2)
        mainview.addSubview(v3)
        
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        
        let c1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: nil, metrics: nil, views: ["v":v1]) as! [NSLayoutConstraint]
        let c2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: nil, metrics: nil, views: ["v":v2]) as! [NSLayoutConstraint]
        let c3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: nil, metrics: nil, views: ["v":v3]) as! [NSLayoutConstraint]
        let c4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(100)-[v(20)]", options: nil, metrics: nil, views: ["v":v1]) as! [NSLayoutConstraint]
        let c5with = NSLayoutConstraint.constraintsWithVisualFormat("V:[v1]-(20)-[v2(20)]-(20)-[v3(20)]", options: nil, metrics: nil, views: ["v1":v1, "v2":v2, "v3":v3]) as! [NSLayoutConstraint]
        let c5without = NSLayoutConstraint.constraintsWithVisualFormat("V:[v1]-(20)-[v3(20)]", options: nil, metrics: nil, views: ["v1":v1, "v3":v3]) as! [NSLayoutConstraint]
        self.constraintsWith.extend(c1)
        self.constraintsWith.extend(c2)
        self.constraintsWith.extend(c3)
        self.constraintsWith.extend(c4)
        self.constraintsWith.extend(c5with)
        
        self.constraintsWithout.extend(c1)
        self.constraintsWithout.extend(c3)
        self.constraintsWithout.extend(c4)
        self.constraintsWithout.extend(c5without)

        mainview.addConstraints(self.constraintsWith)
    }

    func doSwap() {
        let mainview = self.view
        if self.v2.superview != nil {
            self.v2.removeFromSuperview()
            mainview.removeConstraints(self.constraintsWith)
            mainview.addConstraints(self.constraintsWithout)
        } else {
            mainview.addSubview(v2)
            mainview.removeConstraints(self.constraintsWithout)
            mainview.addConstraints(self.constraintsWith)
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

