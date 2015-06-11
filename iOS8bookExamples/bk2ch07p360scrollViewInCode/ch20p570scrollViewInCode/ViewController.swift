

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
        
        let sv = UIScrollView(frame: self.view.bounds)
        sv.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.view.addSubview(sv)
        sv.backgroundColor = UIColor.whiteColor()
        var y : CGFloat = 10
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPointMake(10,y)
            sv.addSubview(lab)
            y += lab.bounds.size.height + 10
            
            // uncomment
//            lab.frame.size.width = self.view.bounds.size.width - 20
//            lab.backgroundColor = UIColor.redColor() // make label bounds visible
//            lab.autoresizingMask = .FlexibleWidth
            
        }
        var sz = sv.bounds.size
        sz.height = y
        sv.contentSize = sz // This is the crucial line
        
        println(sv.contentSize)
        
        delay(2) {
            println(sv.contentSize)
        }
        
        

    }
    
}
