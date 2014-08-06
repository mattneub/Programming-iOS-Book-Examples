

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ContentView : UIView {
    var ics = CGSizeZero
    override func intrinsicContentSize() -> CGSize {
        return self.ics
    }
}

class ViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.whiteColor()
        sv.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(sv)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[sv]|",
                options:nil, metrics:nil,
                views:["sv":sv]))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[sv]|",
                options:nil, metrics:nil,
                views:["sv":sv]))
        
        // demonstrating workaround for case 2 failure in previous example
        // v must be a view that has an intrinsic size...
        // ...so that we do not set explicit width and height constraints on it
        
        // THIS BUG WAS FIXED IN SEED 5
        // This example, though it works, is no longer needed
        
        let v = ContentView() // content view
        sv.addSubview(v)
        
        // content view uses explicit constraints
        // subviews don't use explicit constraints
        
        var y : CGFloat = 10
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPointMake(10,y)
            v.addSubview(lab) // *
            y += lab.bounds.size.height + 10
        }
        
        // set content view width, height, and frame-to-superview constraints
        // content size is calculated for us
        v.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        v.ics = CGSizeMake(0,y) // * this comes back to us thru intrinsic content size
        
        // NB no explicit width/height here
        sv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",
                options:nil, metrics:nil, views:["v":v]))
        sv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|",
                options:nil, metrics:nil, views:["v":v]))
            
        
        delay(2) {
            println(sv.contentSize)
        }

    }
    
    
}
