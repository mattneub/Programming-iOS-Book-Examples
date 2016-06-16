

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

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var iv : UIImageView!
    var didSetup = false
    var oldBounces = false
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            let v = self.viewForZooming(in:self.sv)!
            self.sv.contentSize = v.bounds.size
            self.sv.contentOffset = CGPoint(40,0)
            self.centerView()
        }
    }
    
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }
    
    func centerView() {
        let sv = self.sv!
        let v = self.viewForZooming(in:sv)!
        // normal result is that iv.center should be center of v
        var c = CGPoint(v.bounds.midX,v.bounds.midY)
        // but if dimension is smaller, we will move to center of scroll view
        let csv = CGPoint(sv.bounds.midX,sv.bounds.midY)
        // for x, center in s.v. only if width is smaller
        if sv.contentSize.width < sv.bounds.width {
            let c2 = v.convert(csv, from: sv)
            c.x = c2.x
        } else {
            // offset content to be horizontally centered itself
            sv.contentOffset.x = (sv.contentSize.width - sv.bounds.width) / 2.0
        }
        // for y, always keep centered
        let c2 = v.convert(csv, from: sv)
        c.y = c2.y
        // and set image view's center
        iv.center = c
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerView()
    }
    
    // image view is zoomable

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    // image view is also zoomable by double-tapping
    
    @IBAction func tapped(_ tap : UIGestureRecognizer) {
        let sv = self.sv!
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
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        if let result = super.hitTest(point, with:event) {
            return result
        }
        for sub in self.subviews.reversed() {
            let pt = self.convert(point, to:sub)
            if let result = sub.hitTest(pt, with:event) {
                return result
            }
        }
        return nil
    }
}
