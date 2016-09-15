
import UIKit

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        sv.scrollIndicatorInsets = sv.contentInset
        
        
        sv.backgroundColor = UIColor.whiteColor()
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        var con = [NSLayoutConstraint]()
        con.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[sv]|",
                options:[], metrics:nil,
                views:["sv":sv]))
        con.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[sv]|",
                options:[], metrics:nil,
                views:["sv":sv]))
        var previousLab : UILabel? = nil
        for i in 0 ..< 30 {
            let lab = UILabel()
            // lab.backgroundColor = UIColor.redColor()
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.text = "This is label \(i+1)"
            sv.addSubview(lab)
            con.appendContentsOf(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-(10)-[lab]",
                    options:[], metrics:nil,
                    views:["lab":lab]))
            if previousLab == nil { // first one, pin to top
                con.appendContentsOf(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:|-(10)-[lab]",
                        options:[], metrics:nil,
                        views:["lab":lab]))
            } else { // all others, pin to previous
                con.appendContentsOf(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:[prev]-(10)-[lab]",
                        options:[], metrics:nil,
                        views:["lab":lab, "prev":previousLab!]))
            }
            previousLab = lab
        }
        
        // last one, pin to bottom, this dictates content size height!
        con.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[lab]-(10)-|",
                options:[], metrics:nil,
                views:["lab":previousLab!]))
        NSLayoutConstraint.activateConstraints(con)
        
    }

    
    
}