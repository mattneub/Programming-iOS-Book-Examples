

import UIKit

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
    var oldBounces = false
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var v: UIView!
    var didSetup = false
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            // turn off auto layout and assign content size manually
            self.sv.contentSize = CGSize(208,238)
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    // same annoying "jump" bug in iOS 8
    // there is also a slight "jump" as we zoom
    
    @IBAction func tapped(_ tap : UIGestureRecognizer) {
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
        var which : Int {return 1}
        switch which {
        case 1:
            // print("layout")
            super.layoutSubviews()
            if let v = self.delegate?.viewForZooming?(in:self) {
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

        default:break
        }
    }
    
}
