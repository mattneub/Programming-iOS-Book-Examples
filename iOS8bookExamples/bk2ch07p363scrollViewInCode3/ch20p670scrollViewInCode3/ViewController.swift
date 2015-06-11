

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
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
        
        let v = UIView() // content view
        sv.addSubview(v)
        
        let which = 1
        switch which {
        case 1:
            
            // content view doesn't use explicit constraints
            // subviews don't use explicit constraints either
            
            var y : CGFloat = 10
            for i in 0 ..< 30 {
                let lab = UILabel()
                lab.text = "This is label \(i+1)"
                lab.sizeToFit()
                lab.frame.origin = CGPointMake(10,y)
                v.addSubview(lab) // *
                y += lab.bounds.size.height + 10
            }
            
            // set content view frame and content size explicitly
            v.frame = CGRectMake(0,0,0,y)
            sv.contentSize = v.frame.size
            
        case 2:
            
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
            sv.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v(y)]|",
                    options:nil, metrics:["y":y], views:["v":v]))
            sv.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|[v(0)]|",
                    options:nil, metrics:nil, views:["v":v]))
                        
        case 3:
            // content view uses explicit constraints
            // subviews use explicit constraints

            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = UIColor.redColor()
                lab.setTranslatesAutoresizingMaskIntoConstraints(false)
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                v.addConstraints( // *
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "H:|-(10)-[lab]",
                        options:nil, metrics:nil,
                        views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    v.addConstraints( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:|-(10)-[lab]",
                            options:nil, metrics:nil,
                            views:["lab":lab]))
                } else { // all others, pin to previous
                    v.addConstraints( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:[prev]-(10)-[lab]",
                            options:nil, metrics:nil,
                            views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            v.addConstraints( // *
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[lab]-(10)-|",
                    options:nil, metrics:nil,
                    views:["lab":previousLab!]))

            
            // set content view width and frame-to-superview constraints
            // (height comes from subview constraints)
            // content size is calculated for us
            v.setTranslatesAutoresizingMaskIntoConstraints(false)
            sv.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",
                    options:nil, metrics:nil, views:["v":v])) // *
            sv.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|",
                    options:nil, metrics:nil, views:["v":v]))
            
        case 4:
            // content view doesn't use explicit constraints
            // subviews do explicit constraints
            
            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = UIColor.redColor()
                lab.setTranslatesAutoresizingMaskIntoConstraints(false)
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                v.addConstraints( // *
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "H:|-(10)-[lab]",
                        options:nil, metrics:nil,
                        views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    v.addConstraints( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:|-(10)-[lab]",
                            options:nil, metrics:nil,
                            views:["lab":lab]))
                } else { // all others, pin to previous
                    v.addConstraints( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:[prev]-(10)-[lab]",
                            options:nil, metrics:nil,
                            views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            v.addConstraints( // *
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[lab]-(10)-|",
                    options:nil, metrics:nil,
                    views:["lab":previousLab!]))
            
            // autolayout helps us learn the consequences of those constraints
            let minsz = v.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            
            // set content view frame and content size explicitly
            v.frame = CGRectMake(0,0,0,minsz.height)
            sv.contentSize = v.frame.size

        default: break
        }
        
        delay(2) {
            println(sv.contentSize)
        }

    }
    
    
}
