
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
        self.addChild(vc) // "will" called for us
        vc.view.frame = self.panel.bounds
        self.panel.addSubview(vc.view) // insert view into interface between "will" and "did"
        // note: when we call add, we must call "did" afterwards
        vc.didMove(toParent: self)
        
        self.constrainInPanel(vc.view) // *
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
            from:fromvc,
            to:tovc,
            duration:0.4,
            options:.transitionFlipFromLeft,
            animations: {
                self.constrainInPanel(tovc.view) // *
        }) { _ in
            // when we call add, we must call "did" afterwards
            tovc.didMove(toParent: self)
            fromvc.removeFromParent() // "did" called for us
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func constrainInPanel(_ v:UIView) {
        print("constrain")
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|", metrics:nil, views:["v":v]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|", metrics:nil, views:["v":v])
            ].flatMap{$0})
    }
    
    // a different way (don't use both!)
    // however, I like the first way better, as it is called just once
    // at exactly the right moment
    
    override func viewWillLayoutSubviews() {
        // if you uncomment this, comment out the two calls to constrainInPanel()
        // and vice versa
        // self.constrainInPanel2(self.panel.subviews[0] as UIView)
    }
    
    func constrainInPanel2(_ v:UIView) {
        print("constrain2")
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(self.constraints)
        self.constraints.removeAll()
        self.constraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|", metrics:nil, views:["v":v]))
        self.constraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|", metrics:nil, views:["v":v]))
        NSLayoutConstraint.activate(self.constraints)
    }
}
