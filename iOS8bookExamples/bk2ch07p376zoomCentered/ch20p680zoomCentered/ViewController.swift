

import UIKit

class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var iv : UIImageView!
    var didSetup = false
    var oldBounces = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            // work around auto layout bug in iOS 8
            // turn off auto layout and assign content size manually
            // even in seed 5 I can't get this entire example to work at all in iOS 8...
            // ...if auto layout is on
            self.sv.contentSize = CGSizeMake(400,300)
            
            // nice to have horizontal centering at startup
            // the scroll view layout goes first, gives us vertical centering
            let pt = CGPointMake((self.iv.bounds.width - self.sv.bounds.width)/2.0,0)
            self.sv.setContentOffset(pt, animated:false)
        }
    }
    
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }

    
    // image view is zoomable

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    // image view is also zoomable by double-tapping
    
    // unfortunately there is now a "jump" in iOS 8 as the zoom starts
    // we can prevent this by setting animated: to false throughout
    // but it seems a pity to have to do that
    
    @IBAction func tapped(tap : UIGestureRecognizer) {
        let v = tap.view!
        let sv = v.superview as! UIScrollView
        if sv.zoomScale < 1 {
            sv.setZoomScale(1, animated:true)
            let pt = CGPointMake((v.bounds.width - sv.bounds.width)/2.0,0)
            sv.setContentOffset(pt, animated:false)
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
        // see WWDC 2010 video on this topic
        // comment this out and zoom the bird image smaller to see the difference
        // println("layout")
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
