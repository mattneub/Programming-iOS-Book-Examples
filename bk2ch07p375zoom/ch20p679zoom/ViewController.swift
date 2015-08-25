

import UIKit

class ViewController : UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
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
        
        let v = UIView() // content view
        sv.addSubview(v)
        NSLayoutConstraint.activateConstraints(con)

        var w : CGFloat = 0
        var y : CGFloat = 10
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPointMake(10,y)
            v.addSubview(lab)
            y += lab.bounds.size.height + 10
            
            if lab.bounds.width > w { // *
                w = lab.bounds.width
            }
        }
        
        // set content view frame and content size explicitly
        v.frame = CGRectMake(0,0,w+20,y)
        sv.contentSize = v.frame.size

        v.tag = 999 // *
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 2.0
        sv.delegate = self
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    /*
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        print(scrollView.bounds.size) // this is constant
        print(scrollView.contentSize) // this is changing
        let v = self.viewForZoomingInScrollView(scrollView)!
        print(v.bounds.size) // this is constant
        print(v.frame.size) // this is changing (and here it matches the content size)
        print()
    }

*/
    
    
}
