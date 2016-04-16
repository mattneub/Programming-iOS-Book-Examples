

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

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
    
    let which = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white()
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        var con = [NSLayoutConstraint]()

        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|[sv]|",
                options:[], metrics:nil,
                views:["sv":sv]))
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
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
                lab.frame.origin = CGPoint(10,y)
                v.addSubview(lab) // *
                y += lab.bounds.size.height + 10
            }
            
            // set content view frame and content size explicitly
            v.frame = CGRect(0,0,0,y)
            sv.contentSize = v.frame.size
            NSLayoutConstraint.activate(con)
            
        case 2:
            
            // content view uses explicit constraints
            // subviews don't use explicit constraints
            
            var y : CGFloat = 10
            for i in 0 ..< 30 {
                let lab = UILabel()
                lab.text = "This is label \(i+1)"
                lab.sizeToFit()
                lab.frame.origin = CGPoint(10,y)
                v.addSubview(lab) // *
                y += lab.bounds.size.height + 10
            }
            
            // set content view width, height, and frame-to-superview constraints
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v(y)]|",
                    options:[], metrics:["y":y as NSNumber], views:["v":v]))
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|[v(0)]|",
                    options:[], metrics:nil, views:["v":v]))
            NSLayoutConstraint.activate(con)

            
        case 3:
            // content view uses explicit constraints
            // subviews use explicit constraints

            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = UIColor.red()
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                con.append(contentsOf: // *
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "H:|-(10)-[lab]",
                        options:[], metrics:nil,
                        views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:|-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab]))
                } else { // all others, pin to previous
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:[prev]-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            con.append(contentsOf: // *
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:[lab]-(10)-|",
                    options:[], metrics:nil,
                    views:["lab":previousLab!]))

            
            // pin content view to scroll view, sized by its subview constraints
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|",
                    options:[], metrics:nil, views:["v":v])) // *
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|",
                    options:[], metrics:nil, views:["v":v])) // *
            NSLayoutConstraint.activate(con)

            
        case 4:
            // content view doesn't use explicit constraints
            // subviews do explicit constraints
            
            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                // lab.backgroundColor = UIColor.red()
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                con.append(contentsOf: // *
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "H:|-(10)-[lab]",
                        options:[], metrics:nil,
                        views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:|-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab]))
                } else { // all others, pin to previous
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:[prev]-(10)-[lab]",
                            options:[], metrics:nil,
                            views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }
            
            // last one, pin to bottom, this dictates content size height!
            con.append(contentsOf: // *
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:[lab]-(10)-|",
                    options:[], metrics:nil,
                    views:["lab":previousLab!]))
            NSLayoutConstraint.activate(con)
            
            // autolayout helps us learn the consequences of those constraints
            
            let minsz = v.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            // set content view frame and content size explicitly
            v.frame = CGRect(0,0,0,minsz.height)
            sv.contentSize = v.frame.size

        default: break
        }
        
        delay(2) {
            print(sv.contentSize)
        }

    }
    
    
}
