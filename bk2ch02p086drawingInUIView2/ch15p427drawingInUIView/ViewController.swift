
import UIKit

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mv = MyView(frame:CGRectZero)
        self.view.addSubview(mv)
        mv.translatesAutoresizingMaskIntoConstraints = false
        
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-25-[v]-25-|", options: [], metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[v(150)]", options: [], metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraint(
            NSLayoutConstraint(item: mv, attribute: .CenterY, relatedBy: .Equal, toItem: mv.superview, attribute: .CenterY, multiplier: 1, constant: 0)
        )
        
    }
    
    
}
