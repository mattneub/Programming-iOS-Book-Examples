

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

extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}





class ViewController: UIViewController {
    @IBOutlet weak var v: UIView!
    var anim : UIViewPropertyAnimator!
    @IBOutlet weak var slider: UISlider!
    var didConfig = false
    var pTarget = CGPoint.zero
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didConfig {
            didConfig = true
            let b = self.slider.bounds
            do {
                let r = self.slider.thumbRect(forBounds: b, trackRect: self.slider.trackRect(forBounds: b), value: 0)
                let c = r.center
                let c2 = self.view.convert(c, from:self.slider)
                self.v.center.x = c2.x
            }
            do {
                let r = self.slider.thumbRect(forBounds: b, trackRect: self.slider.trackRect(forBounds: b), value: 1)
                let c = r.center
                let c2 = self.view.convert(c, from:self.slider)
                self.pTarget = c2
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.anim = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.v.center.x = self.pTarget.x
            self.v.backgroundColor = .green
        }
        // uncomment to see the point of this property
        if #available(iOS 11.0, *) {
            // self.anim.scrubsLinearly = false
        }

    }
    
    @IBAction func doSlider(_ slider: UISlider) {
        self.anim.fractionComplete = CGFloat(slider.value)
    }

}

