

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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // a fresh look at the problem of helping with layout in code
    // first problem: we don't necessarily get "willTransition" messages on launch
    // so if there is a view that must be placed into the interface, that isn't where to do it
    // what we _know_ we'll get at launch is "transitionDidChange" and "viewWillLayout"
    
    weak var blackSquare : UIView?
    override func viewWillLayoutSubviews() {
        if self.blackSquare == nil { // both reference and flag
            let v = UIView(frame:CGRect(0,0,10,10))
            v.backgroundColor = .black
            v.center = CGPoint(self.view.bounds.width/2,5)
            self.view.addSubview(v)
            self.blackSquare = v
        }
    }
    
    // if we _subsequently_ change size, e.g. because of rotation
    // we will get "willTransition"
    // here we must make sure we do nothing if we don't have to
    
    
    let which = 3
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        if size != self.view.bounds.size {
            switch which {
            case 1:
                // this one isn't going to work; we haven't changed size yet!
                if let v = self.blackSquare {
                    v.center = CGPoint(self.view.bounds.width/2,5)
                }
            case 2:
                // this better, but if we rotate, we see a blip as the square jumps
                coordinator.animate(alongsideTransition: nil) { _ in
                    if let v = self.blackSquare {
                        v.center = CGPoint(self.view.bounds.width/2,5)
                    }
                }
            case 3:
                // ahh, just right
                coordinator.animate(alongsideTransition:{ _ in
                    if let v = self.blackSquare {
                        v.center = CGPoint(self.view.bounds.width/2,5)
                    }
                })
            default:break
            }
            
            
        }
        else { print("nothing to do") }
    }
    
    
}

