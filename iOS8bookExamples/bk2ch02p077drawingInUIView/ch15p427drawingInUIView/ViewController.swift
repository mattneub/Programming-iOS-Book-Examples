
import UIKit

func delay(delay:Double, closure:()->()) {
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
        
        mv.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-25-[v]-25-|", options: nil, metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[v(150)]", options: nil, metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraint(
            NSLayoutConstraint(item: mv, attribute: .CenterY, relatedBy: .Equal, toItem: mv.superview, attribute: .CenterY, multiplier: 1, constant: 0)
        )
        
        return; // comment out to experiment with resizing
        
        delay(0.1) {
            mv.bounds.size.height *= 2
        }
    }
    
    
}
