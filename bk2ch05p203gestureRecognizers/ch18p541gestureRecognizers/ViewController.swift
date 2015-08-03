

import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    let which = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view that can be single-tapped, double-tapped, or dragged
        
        let t2 = UITapGestureRecognizer(target:self, action:"doubleTap")
        t2.numberOfTapsRequired = 2
        self.v.addGestureRecognizer(t2)
        
        let t1 = UITapGestureRecognizer(target:self, action:"singleTap")
        t1.requireGestureRecognizerToFail(t2)
        self.v.addGestureRecognizer(t1)

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
        print("single tap")
    }
    func doubleTap () {
        print("double tap")
    }
    
    func dragging(p : UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .Began, .Changed:
            let delta = p.translationInView(v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            p.setTranslation(CGPointZero, inView: v.superview)
        default: break
        }
    }

}
