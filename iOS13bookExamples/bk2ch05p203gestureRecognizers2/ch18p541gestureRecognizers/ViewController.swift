

import UIKit

// "layout-driven" implementation of draggable view

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    var vCenter : CGPoint? {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vCenter = self.v.center
        let p = UIPanGestureRecognizer(target: self, action: #selector(dragging))
        self.v.addGestureRecognizer(p)
    }
    @objc func dragging(_ p : UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview)
            var c = self.vCenter!
            c.x += delta.x; c.y += delta.y
            self.vCenter = c
            p.setTranslation(.zero, in: v.superview)
        default: break
        }
    }
    override func viewWillLayoutSubviews() {
        if let c = self.vCenter {
            self.v.center = c
        }
    }
    
}
