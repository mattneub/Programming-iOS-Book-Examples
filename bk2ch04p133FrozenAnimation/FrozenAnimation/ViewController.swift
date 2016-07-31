

import UIKit

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
                let c = CGPoint(x:r.midX, y:r.midY)
                let c2 = self.view.convert(c, from:self.slider)
                self.v.center.x = c2.x
            }
            do {
                let r = self.slider.thumbRect(forBounds: b, trackRect: self.slider.trackRect(forBounds: b), value: 1)
                let c = CGPoint(x:r.midX, y:r.midY)
                let c2 = self.view.convert(c, from:self.slider)
                self.pTarget = c2
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.v.center.x = self.pTarget.x
            self.v.backgroundColor = .green()
        }

    }
    
    @IBAction func doSlider(_ slider: UISlider) {
        self.anim.fractionComplete = CGFloat(slider.value)
    }

}

