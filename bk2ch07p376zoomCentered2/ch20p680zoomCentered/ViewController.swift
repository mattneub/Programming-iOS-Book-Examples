

import UIKit

/*

Not in the book (too difficult to describe!),
but this is a pretty nice way to keep a zoomable view centered
under the weird circumstances I seem to have created for myself...
...where the view is smaller in one dimension than the scroll view

Extremely tricky, and there's a slight dip as we animate double-tap-and-zoom,
but it's also extremely robust
(whereas iOS 8 did nasty things to my previous way of doing this)

*/

class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var iv : UIImageView!
    var didSetup = false
    var oldBounces = false
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            let v = self.viewForZoomingInScrollView(self.sv)!
            self.sv.contentSize = v.bounds.size
            self.sv.contentOffset = CGPointMake(40,0)
        }
    }
    
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }
    
    func centerView() {
        let sv = self.sv
        let v = self.viewForZoomingInScrollView(sv)!
        // normal result is that iv.center should be center of v
        var c = CGPointMake(v.bounds.midX,v.bounds.midY)
        // but if dimension is smaller, we will move to center of scroll view
        let csv = CGPointMake(sv.bounds.midX,sv.bounds.midY)
        // for x, center in s.v. only if width is smaller
        if sv.contentSize.width < sv.bounds.width {
            let c2 = v.convertPoint(csv, fromView: sv)
            c.x = c2.x
        } else {
            // offset content to be horizontally centered itself
            sv.contentOffset.x = (sv.contentSize.width - sv.bounds.width) / 2.0
        }
        // for y, always keep centered
        let c2 = v.convertPoint(csv, fromView: sv)
        c.y = c2.y
        // and set image view's center
        iv.center = c
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerView()
    }
    
    // image view is zoomable

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    // image view is also zoomable by double-tapping
    
    @IBAction func tapped(tap : UIGestureRecognizer) {
        let sv = self.sv
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

class MyTappableView : UIView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        if let result = super.hitTest(point, withEvent:event) {
            return result
        }
        for sub in self.subviews.reverse() as! [UIView] {
            let pt = self.convertPoint(point, toView:sub)
            if let result = sub.hitTest(pt, withEvent:event) {
                return result
            }
        }
        return nil
    }
}
