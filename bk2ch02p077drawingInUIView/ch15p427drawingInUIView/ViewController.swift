
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mv = MyView()
        // mv.backgroundColor = .yellow
        self.view.addSubview(mv)
        
        mv.translatesAutoresizingMaskIntoConstraints = false

        mv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        mv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        let h = mv.heightAnchor.constraint(equalToConstant: 150)
        h.isActive = true
        mv.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        //return; // comment out to experiment with resizing
        
        Task {
            // in the book:
            // mv.bounds.size.height *= 2
            h.constant *= 2
        }
    }
    
    
}
