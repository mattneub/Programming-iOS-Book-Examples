
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var panel : UIView!
    var cur : Int = 0
    var swappers = [UIViewController]()
    var constraints = [NSLayoutConstraint]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.swappers += [FirstViewController()]
        self.swappers += [SecondViewController()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.swappers[cur]
        self.addChildViewController(vc) // "will" called for us
        vc.view.frame = self.panel.bounds
        self.panel.addSubview(vc.view) // insert view into interface between "will" and "did"
        // note: when we call add, we must call "did" afterwards
        vc.didMoveToParentViewController(self)
        
        self.constrainInPanel(vc.view) // *
    }
    
    @IBAction func doFlip(sender:AnyObject?) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds
        
        // must have both as children before we can transition between them
        self.addChildViewController(tovc) // "will" called for us
        // note: when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMoveToParentViewController(nil)
        // then perform the transition
        self.transitionFromViewController(fromvc,
            toViewController:tovc,
            duration:0.4,
            options:.TransitionFlipFromLeft,
            animations: {
                self.constrainInPanel(tovc.view) // *
            },
            completion:{
                _ in
                // finally, finish up
                // note: when we call add, we must call "did" afterwards
                tovc.didMoveToParentViewController(self)
                fromvc.removeFromParentViewController() // "did" called for us
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            })
    }
    
    func constrainInPanel(v:UIView) {
        println("constrain")
        v.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.panel.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options:nil, metrics:nil, views:["v":v]))
        self.panel.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options:nil, metrics:nil, views:["v":v]))
    }
    
    // a different way (don't use both!)
    // however, I like the first way better, as it is called just once
    // at exactly the right moment
    
    override func viewWillLayoutSubviews() {
        // if you uncomment this, comment out the two calls to constrainInPanel()
        // and vice versa
        // self.constrainInPanel2(self.panel.subviews[0] as UIView)
    }
    
    func constrainInPanel2(v:UIView) {
        println("constrain2")
        v.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.panel.removeConstraints(self.constraints)
        self.constraints.removeAll()
        self.constraints.extend(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options:nil, metrics:nil, views:["v":v]) as! [NSLayoutConstraint])
        self.constraints.extend(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options:nil, metrics:nil, views:["v":v]) as! [NSLayoutConstraint])
        self.panel.addConstraints(self.constraints)
    }
}