

import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tests to prove that a multi-edge edge g.r. doesn't work at all
        
        let e = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edge))
        e.edges = [.bottom, .left]
        // self.view.addGestureRecognizer(e)
        
        let e2 = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edge2))
        e2.edges = .left
        self.view.addGestureRecognizer(e2)

        
        // view that can be single-tapped, double-tapped, or dragged
        
        let t2 = UITapGestureRecognizer(target:self, action:#selector(doubleTap))
        t2.numberOfTapsRequired = 2
        self.v.addGestureRecognizer(t2)
        
        let t1 = UITapGestureRecognizer(target:self, action:#selector(singleTap))
        t1.require(toFail:t2) // *
        self.v.addGestureRecognizer(t1)
        
        var which : Int { return 1 }

        switch which {
        case 1:
            let p = UIPanGestureRecognizer(target: self, action: #selector(dragging))
            self.v.addGestureRecognizer(p)
        case 2:
            let p = HorizPanGestureRecognizer(target: self, action: #selector(dragging))
            self.v.addGestureRecognizer(p)
            let p2 = VertPanGestureRecognizer(target: self, action: #selector(dragging))
            self.v.addGestureRecognizer(p2)

        default: break
        }
    }
    
    @objc func edge () {
        print("edge")
    }
    
    @objc func edge2 () {
        print("edge2")
    }

    
    @objc func singleTap () {
        print("single tap")
    }
    @objc func doubleTap () {
        print("double tap")
    }
    
    @objc func dragging(_ p : UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            p.setTranslation(.zero, in: v.superview)
        default: break
        }
    }

}
