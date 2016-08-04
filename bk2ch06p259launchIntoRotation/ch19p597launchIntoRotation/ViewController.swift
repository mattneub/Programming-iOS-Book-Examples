

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UIViewController {
    var viewInitializationDone = false
    
    let which = 3
    
    override func viewDidLoad() {
        print(self.view.bounds.size)
        super.viewDidLoad()
        
        if which == 1 {
            // this was too soon in iOS 7 (the app launched in portrait), but...
            // in iOS 8, this approach actually works surprisingly well
            // by the time `viewDidLoad` is called, the entire screen has _already_ rotated...
            // to its initial orientation (the first one listed in the Info.plist)
            // thus, although self.view may be resized further as it is placed into the interface...
            // it is at least in the right orientation already
            // in iOS 9, this approach won't work on an iPhone held in landscape at launch...
            // ...unless we add autoresizing
            let square = UIView(frame:CGRect(0,0,10,10))
            square.backgroundColor = .black
            square.center = CGPoint(self.view.bounds.midX,5) // top center?
            //square.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
            self.view.addSubview(square)
        } else if which == 3 {
            // on the other hand, using constraints and no hard numbers is most reliable
            // and of course it has the advantage of being adaptable into future rotations
            let square = UIView()
            square.backgroundColor = .black
            self.view.addSubview(square)
            square.translatesAutoresizingMaskIntoConstraints = false
            let side : CGFloat = 10
            var con = [NSLayoutConstraint]()
            con.append(contentsOf:[
                square.widthAnchor.constraint(equalToConstant:side),
                square.centerXAnchor.constraint(equalTo:self.view.centerXAnchor)
                ])
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[square(side)]",
                    metrics:["side":side],
                    views:["square":square]))
            NSLayoutConstraint.activate(con)
        }
    }
    
    override func viewWillLayoutSubviews() {
        print("will layout \(self.view.bounds.size)")
        
        if which == 2 {
            // this was formerly my favorite place...
            // ...but now it doesn't work either if we launch into landscape on iPhone!
            // that's because we always launch into portrait and then rotate
            if !self.viewInitializationDone {
                self.viewInitializationDone = true
                let square = UIView(frame:CGRect(0,0,10,10))
                square.backgroundColor = .black
                square.center = CGPoint(self.view.bounds.midX,5)
                self.view.addSubview(square)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if which == 4 {
            if !self.viewInitializationDone {
                self.viewInitializationDone = true
                let square = UIView(frame:CGRect(0,0,10,10))
                square.backgroundColor = .black
                square.center = CGPoint(self.view.bounds.midX,5)
                self.view.addSubview(square)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("did layout \(self.view.bounds.size)")
        
        
    }
    
    
}


