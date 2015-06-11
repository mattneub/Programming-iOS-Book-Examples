
import UIKit

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        sv.scrollIndicatorInsets = sv.contentInset
        
        
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
        var previousLab : UILabel? = nil
        for i in 0 ..< 30 {
            let lab = UILabel()
            // lab.backgroundColor = UIColor.redColor()
            lab.setTranslatesAutoresizingMaskIntoConstraints(false)
            lab.text = "This is label \(i+1)"
            sv.addSubview(lab)
            sv.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-(10)-[lab]",
                    options:nil, metrics:nil,
                    views:["lab":lab]))
            if previousLab == nil { // first one, pin to top
                sv.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:|-(10)-[lab]",
                        options:nil, metrics:nil,
                        views:["lab":lab]))
            } else { // all others, pin to previous
                sv.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:[prev]-(10)-[lab]",
                        options:nil, metrics:nil,
                        views:["lab":lab, "prev":previousLab!]))
            }
            previousLab = lab
        }
        
        // last one, pin to bottom, this dictates content size height!
        sv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[lab]-(10)-|",
                options:nil, metrics:nil,
                views:["lab":previousLab!]))
        
    }

    
    
}