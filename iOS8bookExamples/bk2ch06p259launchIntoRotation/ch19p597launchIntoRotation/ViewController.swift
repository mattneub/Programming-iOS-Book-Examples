

import UIKit

class ViewController : UIViewController {
    var viewInitializationDone = false
    
    let which = 1
    
    override func viewDidLoad() {
        println(self.view.bounds.size)
        super.viewDidLoad()
        
        if which == 1 {
            // this was too soon in iOS 7 (the app launched in portrait), but...
            // in iOS 8, this approach actually works surprisingly well
            // by the time `viewDidLoad` is called, the entire screen has _already_ rotated...
            // to its initial orientation (the first one listed in the Info.plist)
            // thus, although self.view may be resized further as it is placed into the interface...
            // it is at least in the right orientation already
            let square = UIView(frame:CGRectMake(0,0,10,10))
            square.backgroundColor = UIColor.blackColor()
            square.center = CGPointMake(self.view.bounds.midX,5) // top center?
            self.view.addSubview(square)
        } else if which == 3 {
            // on the other hand, using constraints and no hard numbers is most reliable
            // and of course it has the advantage of being adaptable into future rotations
            let square = UIView()
            square.backgroundColor = UIColor.blackColor()
            self.view.addSubview(square)
            square.setTranslatesAutoresizingMaskIntoConstraints(false)
            let side : CGFloat = 10
            square.addConstraint(
                NSLayoutConstraint(item:square, attribute:.Width,
                relatedBy:.Equal,
                toItem:nil, attribute:.NotAnAttribute,
                multiplier:1, constant:side))
            self.view.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[square(side)]",
                options:nil, metrics:["side":side],
                views:["square":square]))
            self.view.addConstraint(
                NSLayoutConstraint(item:square, attribute:.CenterX,
                relatedBy:.Equal,
                toItem:self.view, attribute:.CenterX,
                multiplier:1, constant:0))
        }
    }
    
    override func viewWillLayoutSubviews() {
        println("will layout \(self.view.bounds.size)")
        
        if which == 2 {
            // this is still my favorite place, however
            // it has the advantage that it is called just once on launch...
            // ...and that the view has assumed its final size (e.g. into navigation interface)
            // on the other hand, this will be called many times over the lifetime,
            // so to initialize interface here, we need a flag
            if !self.viewInitializationDone {
                self.viewInitializationDone = true
                let square = UIView(frame:CGRectMake(0,0,10,10))
                square.backgroundColor = UIColor.blackColor()
                square.center = CGPointMake(self.view.bounds.midX,5)
                self.view.addSubview(square)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        println("did layout \(self.view.bounds.size)")
    }
    
    
}


