
import UIKit

class ViewController : UIViewController {
    @IBAction func doButton(_ sender: Any?) {
        print("button tap!")
    }
    
    @IBAction func tapped(_ g:UITapGestureRecognizer) {
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
