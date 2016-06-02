import UIKit

class ViewController2 : UIViewController {
    @IBAction func doButton(_ sender:AnyObject?) {
        self.presenting!.dismiss(animated:true, completion: nil)
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
        self.modalPresentationStyle = .currentContext
    }
}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    @objc(animationControllerForPresentedController:presentingController:sourceController:)
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        
        let r2end = transitionContext.finalFrame(for:vc2)
        
        let v2 = transitionContext.view(forKey:UITransitionContextToViewKey)!
                
        var r2start = r2end
        r2start.origin.y -= r2start.size.height
        v2.frame = r2start
        con.addSubview(v2)
        UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, animations: {
            v2.frame = r2end
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
            })

    }
}