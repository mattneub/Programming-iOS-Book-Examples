


import UIKit

class ViewController : UIViewController {
    var sv : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        self.sv = sv
        
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        var con = [NSLayoutConstraint]()
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|[sv]|",
                metrics:nil,
                views:["sv":sv]))
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|[sv]|",
                metrics:nil,
                views:["sv":sv]))
        var previousLab : UILabel? = nil
        for i in 0 ..< 30 {
            let lab = UILabel()
            // lab.backgroundColor = .red
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.text = "This is label \(i+1)"
            sv.addSubview(lab)
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|-(10)-[lab]",
                    metrics:nil,
                    views:["lab":lab]))
            if previousLab == nil { // first one, pin to top
                con.append(contentsOf:
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "V:|-(10)-[lab]",
                        metrics:nil,
                        views:["lab":lab]))
            } else { // all others, pin to previous
                con.append(contentsOf:
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "V:[prev]-(10)-[lab]",
                        metrics:nil,
                        views:["lab":lab, "prev":previousLab!]))
            }
            previousLab = lab
        }
        
        // last one, pin to bottom, this dictates content size height!
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:[lab]-(10)-|",
                metrics:nil,
                views:["lab":previousLab!]))
        // also need to dictate content size width
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|-[lab]-|",
               metrics:nil,
               views:["lab":previousLab!]))

        
        NSLayoutConstraint.activate(con)
    }
    
    override func viewWillLayoutSubviews() {
        if let sv = self.sv {
//            let safe = self.view.safeAreaInsets
//            sv.contentInset = UIEdgeInsetsMake(safe.top, 0, safe.bottom, 0)
//            sv.scrollIndicatorInsets = self.sv.contentInset
            print(sv.contentInset)
            print(sv.adjustedContentInset)
            // new in iOS 11: content inset is zero...
            // but we show properly anyway! scroll view obeys the safe area automatically
            // and the adjustedContentInset shows this
            // interestingly this works even though we didn't set the behavior to .always
            // is that because it works correctly for top bar but not for status bar alone?
        }
    }
    
}
