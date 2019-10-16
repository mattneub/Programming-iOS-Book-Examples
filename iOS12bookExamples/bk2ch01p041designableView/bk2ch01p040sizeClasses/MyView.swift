

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
    
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//        self.configure()
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder:aDecoder)
//        self.configure()
//    }
    
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
            v2.leftAnchor.constraint(equalTo:self.leftAnchor),
            v2.rightAnchor.constraint(equalTo:self.rightAnchor),
            v2.topAnchor.constraint(equalTo:self.topAnchor),
            v2.heightAnchor.constraint(equalToConstant:20),
            v3.widthAnchor.constraint(equalToConstant:20),
            v3.heightAnchor.constraint(equalTo:v3.widthAnchor),
            v3.rightAnchor.constraint(equalTo:self.rightAnchor),
            v3.bottomAnchor.constraint(equalTo:self.bottomAnchor),
        ])
        
    }
    
    override func prepareForInterfaceBuilder() {
        // IB-only preparations can go here
        // typically this will involve supplying stub data
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        return;
        let lab = UILabel()
        lab.text = self.name
        lab.sizeToFit()
        self.addSubview(lab) // yep: change the inspectable `name` in IB, and the label changes
    }
    
    override func willMove(toSuperview newSuperview: UIView!) {
        self.configure()
    }
    
}

@IBDesignable class MyButton : UIButton {
    @IBInspectable var borderWidth : Int {
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
        get {
            return Int(self.layer.borderWidth)
        }
    }
    // what's the earliest we can pick up the value applied from the nib?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        print("init coder", self.borderWidth) // inspectable value not yet set
    }
    override func awakeFromNib() {
        print("awake1", self.borderWidth)
        super.awakeFromNib()
        print("awake2", self.borderWidth)
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow:newWindow)
        print("will move to window", self.borderWidth)
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview:newSuperview)
        print("will move to superview", self.borderWidth)
    }
}
