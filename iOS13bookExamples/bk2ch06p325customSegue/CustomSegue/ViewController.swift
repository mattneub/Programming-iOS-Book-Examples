

import UIKit

class ViewController: UIViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("did disappear")
    }
}

class ViewController2: UIViewController {
    @IBAction func doDismiss(_ sender: Any) {
        self.dismiss(animated:true)
    }
}

// in iOS 9...
// the segue itself is able to act as animated transitioning object to customize pres. animation
// this is possible because it is retained and still exists at dismissal time
// it can also call super.perform, and in connection with this...
// Xcode 7 lets you specify a custom segue class without saying Custom for the segue:
// we are customizing a standard present modally segue

class MyCoolSegue: UIStoryboardSegue {
    override func perform() {
        let dest = self.destination
        dest.modalPresentationStyle = .custom // teehee
        dest.transitioningDelegate = self
        super.perform()
    }
}
extension MyCoolSegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        print("just checking")
        return nil
    }

}
extension MyCoolSegue: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let vc1 = ctx.viewController(forKey:.from)!
        let vc2 = ctx.viewController(forKey:.to)!
        
        let con = ctx.containerView
        
        let r1start = ctx.initialFrame(for:vc1)
        let r2end = ctx.finalFrame(for:vc2)
        
        if let v2 = ctx.view(forKey:.to) {
            print(vc2.modalPresentationStyle.rawValue)
            let p = vc2.presentationController!
            print(p.presentationStyle.rawValue)
            print(p.adaptivePresentationStyle.rawValue)
            print(p.shouldPresentInFullscreen)
            
            var r2start = r2end
            r2start.origin.y -= r2start.size.height
            v2.frame = r2start
            con.addSubview(v2)
            UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, animations: {
                v2.frame = r2end
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
            })
        } else if let v1 = ctx.view(forKey:.from) {
            var r1end = r1start
            r1end.origin.y = -r1end.size.height
            UIView.animate(withDuration:0.8, animations: {
                v1.frame = r1end
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
            })
        }
    }
    


}


