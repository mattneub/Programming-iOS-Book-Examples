

import UIKit

extension NSLayoutConstraint {
    class func reportAmbiguity (var v:UIView?) {
        if v == nil {
            v = UIApplication.sharedApplication().keyWindow
        }
        for vv in v!.subviews as! [UIView] {
            println("\(vv) \(vv.hasAmbiguousLayout())")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (var v:UIView?) {
        if v == nil {
            v = UIApplication.sharedApplication().keyWindow
        }
        for vv in v!.subviews as! [UIView] {
            let arr1 = vv.constraintsAffectingLayoutForAxis(.Horizontal)
            let arr2 = vv.constraintsAffectingLayoutForAxis(.Vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}


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
        
        NSLayoutConstraint.activateConstraints(self.constraintsWith)
    }
    
    @IBAction func doSwap(sender: AnyObject) {
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
}

