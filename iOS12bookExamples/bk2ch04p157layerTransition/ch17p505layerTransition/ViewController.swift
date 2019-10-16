

import UIKit


class ViewController : UIViewController {
    
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lay = CALayer()
        lay.frame = self.v.layer.bounds
        self.v.layer.addSublayer(lay)
        lay.contents = UIImage(named:"Mars")!.cgImage
        lay.contentsGravity = .resizeAspectFill
        self.v.layer.masksToBounds = true // try making this false to see what difference it makes
        self.v.layer.borderWidth = 2
        
    }
    
    @IBAction func doButton(_ sender: Any?) {
        let lay = self.v.layer.sublayers![0]
        let t = CATransition()
        t.type = .push
        t.subtype = .fromBottom
        t.duration = 2
        CATransaction.setDisableActions(true)
        lay.contents = UIImage(named: "Smiley")!.cgImage
        lay.add(t, forKey: nil)

    }
    
}
