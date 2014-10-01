

import UIKit

/*
Similar to previous example, but constraints are conditionally set in code.
We use the new iOS 8 size classes to set the constants of our constraints.
In a more elaborate situation we could actually remove and add entire constraints.
*/

class MyView: UIView {
    
    var c1 : NSLayoutConstraint!
    var c2 : NSLayoutConstraint!
        
    func configure() {
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        v2.setTranslatesAutoresizingMaskIntoConstraints(false)
        v3.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(v2)
        self.addSubview(v3)
        
        self.addConstraint(
            NSLayoutConstraint(item: v2,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Left,
                multiplier: 1, constant: 0)
        )
        self.addConstraint(
            NSLayoutConstraint(item: v2,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Right,
                multiplier: 1, constant: 0)
        )
        self.addConstraint(
            NSLayoutConstraint(item: v2,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Top,
                multiplier: 1, constant: 0)
        )
        self.c1 = NSLayoutConstraint(item: v2,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1, constant: 0) // not really
        v2.addConstraint(c1)
        self.c2 = NSLayoutConstraint(item: v3,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1, constant: 0) // not really
        v3.addConstraint(c2)
        v3.addConstraint(
            NSLayoutConstraint(item: v3,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: v3,
                attribute: .Width,
                multiplier: 1, constant: 0)
        )
        self.addConstraint(
            NSLayoutConstraint(item: v3,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Right,
                multiplier: 1, constant: 0)
        )
        self.addConstraint(
            NSLayoutConstraint(item: v3,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Bottom,
                multiplier: 1, constant: 0)
        )
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        self.configure()
    }
    
    override func updateConstraints() {
        let comp = self.traitCollection.horizontalSizeClass == .Compact
        let d1 : CGFloat = comp ? 10 : 40
        let d2 : CGFloat = comp ? 20 : 80
        self.c1.constant = d1
        self.c2.constant = d2
        println("\(d1) \(d2)")
        super.updateConstraints()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        println("did change")
        self.setNeedsUpdateConstraints()
    }


}
