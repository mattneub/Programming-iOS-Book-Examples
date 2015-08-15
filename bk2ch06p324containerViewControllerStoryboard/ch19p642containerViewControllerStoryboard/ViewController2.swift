import UIKit

class ViewController2 : UIViewController {
    @IBAction func doButton(sender:AnyObject?) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc2 view did load")
    }
}

// ===== the rest of the example actually demonstrates something else entirely,
// namely a current-context presentation (with custom animation)

extension ViewController2 {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transitioningDelegate = self
        self.modalPresentationStyle = .CurrentContext
    }
}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        
        let r2end = transitionContext.finalFrameForViewController(vc2)
        
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)!
                
        var r2start = r2end
        r2start.origin.y -= r2start.size.height
        v2.frame = r2start
        con.addSubview(v2)
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            v2.frame = r2end
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
            })

    }
}