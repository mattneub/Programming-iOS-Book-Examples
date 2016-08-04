
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var panel : UIView!
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // last wild dance with the automatic name-finding
        self.swappers += [FirstViewController(nibName:nil, bundle:nil)]
        self.swappers += [SecondViewController(nibName:nil, bundle:nil)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.swappers[cur]
        self.addChildViewController(vc) // "will" called for us
        vc.view.frame = self.panel.bounds
        self.panel.addSubview(vc.view) // insert view into interface between "will" and "did"
        // note: when we call add, we must call "did" afterwards
        vc.didMove(toParentViewController: self)
    }
    
    @IBAction func doFlip(_ sender:AnyObject?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds
        
        // must have both as children before we can transition between them
        self.addChildViewController(tovc) // "will" called for us
        // note: when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParentViewController: nil)
        // then perform the transition
        self.transition(from:fromvc,
            to:tovc,
            duration:0.4,
            options:.transitionFlipFromLeft,
            animations:nil,
            completion:{
                _ in
                // finally, finish up
                // note: when we call add, we must call "did" afterwards
                tovc.didMove(toParentViewController: self)
                fromvc.removeFromParentViewController() // "did" called for us
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        
    }
}