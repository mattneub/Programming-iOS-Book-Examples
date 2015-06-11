

import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view that can be single-tapped, double-tapped, or dragged
        
        let t2 = UITapGestureRecognizer(target:self, action:"doubleTap")
        t2.numberOfTapsRequired = 2
        self.v.addGestureRecognizer(t2)
        
        let t1 = UITapGestureRecognizer(target:self, action:"singleTap")
        t1.requireGestureRecognizerToFail(t2)
        self.v.addGestureRecognizer(t1)

        let which = 2
        switch which {
        case 1:
            let p = UIPanGestureRecognizer(target: self, action: "dragging:")
            self.v.addGestureRecognizer(p)
        case 2:
            let p = HorizPanGestureRecognizer(target: self, action: "dragging:")
            self.v.addGestureRecognizer(p)
            let p2 = VertPanGestureRecognizer(target: self, action: "dragging:")
            self.v.addGestureRecognizer(p2)

        default: break
        }
    }
    
    func singleTap () {
        println("single tap")
    }
    func doubleTap () {
        println("double tap")
    }
    
    func dragging(p : UIPanGestureRecognizer) {
        let vv = p.view!
        switch p.state {
        case .Began, .Changed:
            let delta = p.translationInView(vv.superview!)
            var c = vv.center
            c.x += delta.x; c.y += delta.y
            vv.center = c
            p.setTranslation(CGPointZero, inView: vv.superview)
        default: break
        }
    }

}
