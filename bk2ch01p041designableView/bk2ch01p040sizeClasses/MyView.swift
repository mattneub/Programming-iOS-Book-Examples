

import UIKit

/*
Demonstrating the Designable View feature.
The view must be marked IBDesignable.
(In early betas of Xcode 6 it also had to live in its own framework, but no longer.)
The result is that the storyboard draws the view more or less as it will appear.
Thus, even though this view adds its own subviews in code, you can still see them in IB!
The representation is not perfect but it's pretty good.
*/

@IBDesignable class MyView: UIView {
    
    @IBInspectable var name : String!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.configure()
    }
    
    func configure() {
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        v2.translatesAutoresizingMaskIntoConstraints = false
        v3.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v2)
        self.addSubview(v3)
        
        NSLayoutConstraint.activate([
            v2.leftAnchor.constraintEqual(to:self.leftAnchor),
            v2.rightAnchor.constraintEqual(to:self.rightAnchor),
            v2.topAnchor.constraintEqual(to:self.topAnchor),
            v2.heightAnchor.constraintEqual(toConstant:10),
            v3.widthAnchor.constraintEqual(toConstant:20),
            v3.heightAnchor.constraintEqual(to:v3.widthAnchor),
            v3.rightAnchor.constraintEqual(to:self.rightAnchor),
            v3.bottomAnchor.constraintEqual(to:self.bottomAnchor),
        ])
    }
    
    override func prepareForInterfaceBuilder() {
        // IB-only preparations can go here
        // typically this will involve supplying stub data
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let lab = UILabel()
        lab.text = self.name
        lab.sizeToFit()
        self.addSubview(lab) // yep: change the inspectable `name` in IB, and the label changes
    }
    
    override func willMove(toSuperview newSuperview: UIView!) {
        // self.configure()
    }
    
    
}
