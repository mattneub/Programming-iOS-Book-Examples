

import UIKit

class ViewController : UIViewController, UIScrollViewDelegate {
    var oldBounces = false
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var v: UIView!
    var didSetup = false
    
    /*
    Unfortunately the custom scroll view for keeping the view centered
    works so badly in iOS 8 that I had to abandon it.
*/
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            // work around auto layout bug in iOS 8
            // turn off auto layout and assign content size manually
            self.sv.contentSize = CGSizeMake(400,300)
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView!, withView view: UIView!) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView!, withView view: UIView!, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return scrollView.viewWithTag(999)
    }
    
    @IBAction func tapped(tap : UIGestureRecognizer) {
        let v = tap.view
        let sv = v.superview as UIScrollView
        if sv.zoomScale < 1 {
            sv.setZoomScale(1, animated:true)
        }
        else if sv.zoomScale < sv.maximumZoomScale {
            sv.setZoomScale(sv.maximumZoomScale, animated:true)
        }
        else {
            sv.setZoomScale(sv.minimumZoomScale, animated:true)
        }
    }
}
