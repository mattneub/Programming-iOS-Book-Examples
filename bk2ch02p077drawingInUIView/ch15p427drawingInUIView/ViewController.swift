
import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mv = MyView()
        self.view.addSubview(mv)
        
        mv.translatesAutoresizingMaskIntoConstraints = false
        
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-25-[v]-25-|", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"V:[v(150)]", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraint(
            NSLayoutConstraint(item: mv, attribute: .centerY, relatedBy: .equal, toItem: mv.superview, attribute: .centerY, multiplier: 1, constant: 0)
        )
        
        return; // comment out to experiment with resizing
        
        delay(0.1) {
            mv.bounds.size.height *= 2
        }
    }
    
    
}
