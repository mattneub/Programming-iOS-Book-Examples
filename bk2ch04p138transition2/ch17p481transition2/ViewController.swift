

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBAction func doButton(sender:AnyObject?) {
        self.animate()
    }
    
    func animate() {
        let lab2 = UILabel(frame:self.lab.frame)
        lab2.text = self.lab.text == "Hello" ? "Howdy" : "Hello"
        lab2.sizeToFit()
        UIView.transitionFromView(self.lab, toView: lab2,
            duration: 0.8, options: .TransitionFlipFromLeft,
            completion: {
                _ in
                self.lab = lab2
            })
    }
    
}
