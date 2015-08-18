

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
    
    let which = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.whiteColor()
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        var con = [NSLayoutConstraint]()

        con.extend(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[sv]|",
                options:[], metrics:nil,
                views:["sv":sv]))
        con.extend(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[sv]|",
                options:[], metrics:nil,
                views:["sv":sv]))
        
        let v = UIView() // content view
        sv.addSubview(v)
        
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
            NSLayoutConstraint.activateConstraints(con)
            
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
            v.translatesAutoresizingMaskIntoConstraints = false
            con.extend(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v(y)]|",
                    options:[], metrics:["y":y], views:["v":v]))
            con.extend(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|[v(0)]|",
                    options:[], metrics:nil, views:["v":v]))
            NSLayoutConstraint.activateConstraints(con)

            
        case 3:
            // content view uses explicit constraints
            // subviews use explicit constraints

            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = UIColor.redColor()
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                con.extend( // *
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "H:|-(10)-[lab]",
                        options:[], metrics:nil,
                        views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    con.extend( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:|-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab]))
                } else { // all others, pin to previous
                    con.extend( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:[prev]-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            con.extend( // *
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[lab]-(10)-|",
                    options:[], metrics:nil,
                    views:["lab":previousLab!]))

            
            // set content view width and frame-to-superview constraints
            // (height comes from subview constraints)
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            con.extend(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",
                    options:[], metrics:nil, views:["v":v])) // *
            con.extend(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|",
                    options:[], metrics:nil, views:["v":v]))
            NSLayoutConstraint.activateConstraints(con)

            
        case 4:
            // content view doesn't use explicit constraints
            // subviews do explicit constraints
            
            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = UIColor.redColor()
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                con.extend( // *
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "H:|-(10)-[lab]",
                        options:[], metrics:nil,
                        views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    con.extend( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:|-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab]))
                } else { // all others, pin to previous
                    con.extend( // *
                        NSLayoutConstraint.constraintsWithVisualFormat(
                            "V:[prev]-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            con.extend( // *
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[lab]-(10)-|",
                    options:[], metrics:nil,
                    views:["lab":previousLab!]))
            NSLayoutConstraint.activateConstraints(con)
            
            // autolayout helps us learn the consequences of those constraints
            
            let minsz = v.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            // set content view frame and content size explicitly
            v.frame = CGRectMake(0,0,0,minsz.height)
            sv.contentSize = v.frame.size

        default: break
        }
        
        delay(2) {
            print(sv.contentSize)
        }

    }
    
    
}
