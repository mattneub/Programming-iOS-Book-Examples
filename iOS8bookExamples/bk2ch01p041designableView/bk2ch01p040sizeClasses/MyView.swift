

import UIKit

/*
Demonstrating the Designable View feature, new in Xcode 6.
The view must be marked IBDesignable.
(In early betas it also had to live in its own framework, but no longer.)
The result is that the storyboard draws the view more or less as it will appear.
Thus, even though this view adds its own subviews in code, you can still see them in IB!
The representation is not perfect but it's pretty good.
*/

@IBDesignable class MyView: UIView {
    
    @IBInspectable var name : String!
    
    // My experience is that you must supply both inits even though they just call super
    // Otherwise IB can crash
    // no longer seems to be needed!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.configure()
    }
    
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
        let c1 = NSLayoutConstraint(item: v2,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1, constant: 10)
        v2.addConstraint(c1)
        let c2 = NSLayoutConstraint(item: v3,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1, constant: 20)
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
    
    override func prepareForInterfaceBuilder() {
        // IB-only preparations can go here
        // typically this will involve supplying stub data
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        // self.configure()
    }
    
    
}
