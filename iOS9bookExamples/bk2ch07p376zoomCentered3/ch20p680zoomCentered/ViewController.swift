

import UIKit

/*

Same as previous example, proving that it works under autolayout
(this is part of what I meant when I said it was robust)

*/

class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var iv : UIImageView!
    var didSetup = false
    var oldBounces = false
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.didSetup {
            self.didSetup = true
            self.centerView() // unsure why, but without this we jump on first zoom
            // doing it in ViewDidLayoutSubviews isn't good enough for some reason
        }
    }
    
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
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
        print(sv.contentOffset)
    }

}

class MyTappableView : UIView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        if let result = super.hitTest(point, withEvent:event) {
            return result
        }
        for sub in self.subviews.reverse() {
            let pt = self.convertPoint(point, toView:sub)
            if let result = sub.hitTest(pt, withEvent:event) {
                return result
            }
        }
        return nil
    }
}
