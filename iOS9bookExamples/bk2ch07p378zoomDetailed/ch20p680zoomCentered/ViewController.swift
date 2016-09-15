

import UIKit

class ViewController : UIViewController, UIScrollViewDelegate {
    var oldBounces = false
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var v: UIView!
    var didSetup = false
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            // turn off auto layout and assign content size manually
            self.sv.contentSize = CGSizeMake(208,238)
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    // same annoying "jump" bug in iOS 8
    // there is also a slight "jump" as we zoom
    
    @IBAction func tapped(tap : UIGestureRecognizer) {
        let v = tap.view!
        let sv = v.superview as! UIScrollView
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

class MyScrollView : UIScrollView {
    
    override func layoutSubviews() {
//        println("layout")
        super.layoutSubviews()
        if let v = self.delegate?.viewForZoomingInScrollView?(self) {
            let svw = self.bounds.width
            let svh = self.bounds.height
            let vw = v.frame.width
            let vh = v.frame.height
            var f = v.frame
            if vw < svw {
                f.origin.x = (svw - vw) / 2.0
            } else {
                f.origin.x = 0
            }
            if vh < svh {
                f.origin.y = (svh - vh) / 2.0
            } else {
                f.origin.y = 0
            }
            v.frame = f
        }
    }
    
}
