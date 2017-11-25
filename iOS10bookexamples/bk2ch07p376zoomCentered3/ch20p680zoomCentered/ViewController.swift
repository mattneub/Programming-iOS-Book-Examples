

import UIKit

/*

Same as previous example, proving that it works under autolayout
(this is part of what I meant when I said it was robust)

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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.didSetup {
            self.didSetup = true
            self.centerView() // unsure why, but without this we jump on first zoom
            // doing it in ViewDidLayoutSubviews isn't good enough for some reason
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
        print(sv.contentOffset)
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
