
import UIKit

class ViewController : UIViewController {
    @IBAction func doButton(_ sender: Any?) {
        print("button tap!")
    }
    
    @available(iOS 13.0, *)
    func checkStatusBar() {
        // just making sure this works even if we don't support window scenes
        if let sc = self.view.window?.windowScene {
            if let sbman = sc.statusBarManager {
                print(sbman.statusBarFrame)
                // 0 default and 1 light, 3 is the new forced dark content
                // ok but it looks like we will never _report_ as 0!
                // we report as 1 or 3, kind of weird though I see the point
                print(sbman.statusBarStyle.rawValue)
                print(sbman.isStatusBarHidden)
            }
        }
    }
    
    @IBAction func tapped(_ g:UITapGestureRecognizer) {
        if #available(iOS 13.0, *) {
            self.checkStatusBar()
        }
        let p = g.location(ofTouch:0, in: g.view)
        let v = g.view?.hitTest(p, with: nil)
        if let v = v as? UIImageView {
            UIView.animate(withDuration:0.2, delay: 0,
                options: .autoreverse,
                animations: {
                    v.transform = CGAffineTransform(scaleX:1.1, y:1.1)
                }, completion: {
                    _ in
                    v.transform = .identity
                })
        }
    }
}



class MyView : UIView {
    
    // the button is a subview of this view... try to tap it
    
    // normally, you can't touch a subview's region outside its superview
    // but you can *see* a subview outside its superview if the superview doesn't clip to bounds,
    // so why shouldn't you be able to touch it?
    // this hitTest override makes it possible
    // try the example with hitTest commented out and with it restored to see the difference

    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, with:e) {
            return result
        }
        for sub in self.subviews.reversed() {
            let pt = self.convert(point, to:sub)
            if let result = sub.hitTest(pt, with:e) {
                return result
            }
        }
        return nil
    }
}
