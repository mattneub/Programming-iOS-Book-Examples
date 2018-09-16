
import UIKit

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mv = MyView(frame:CGRect.zero)
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
        
    }
    
    
}
