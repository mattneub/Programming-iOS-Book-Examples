
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var panel : UIView!
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.swappers += [FirstViewController(nibName:nil, bundle:nil)]
        self.swappers += [SecondViewController(nibName:nil, bundle:nil)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.swappers[cur]
        self.addChild(vc) // "will" called for us
        vc.view.frame = self.panel.bounds
        self.panel.addSubview(vc.view) // insert view into interface between "will" and "did"
        // note: when we call add, we must call "did" afterwards
        vc.didMove(toParent: self)
    }
    @IBAction func doFlip(_ sender: Any?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds
        
        // must have both as children before we can transition between them
        self.addChild(tovc) // "will" called for us
        // when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParent: nil)
        // then perform the transition
        self.transition(
            from:fromvc, to:tovc,
            duration:0.4, options:.transitionFlipFromLeft,
            animations:nil) { _ in
                // when we call add, we must call "did" afterwards
                tovc.didMove(toParent: self)
                fromvc.removeFromParent() // "did" called for us
                UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
}
