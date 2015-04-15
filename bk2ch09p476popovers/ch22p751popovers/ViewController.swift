
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController {
    @IBOutlet var button : UIButton!
    @IBOutlet var button2 : UIButton!
    var oldChoice : Int = -1
    
    // popover handling is completely revised in iOS 8 (at last!)
    // a popover is a form of presented view controller...
    // ...and to configure/modify it,
    // you use the popover presentation controller and act as its delegate
    
    @IBAction func doPopover1(sender:AnyObject?) {
        let vc = Popover1View1()
        // vc.modalInPopover = true
        let nav = UINavigationController(rootViewController: vc)
        let b = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self,
            action: "cancelPop1:")
        vc.navigationItem.rightBarButtonItem = b
        let b2 = UIBarButtonItem(barButtonSystemItem: .Done, target: self,
            action: "savePop1:")
        vc.navigationItem.leftBarButtonItem = b2
        let bb = UIButton.buttonWithType(.InfoDark) as! UIButton
        bb.addTarget(self, action:"doPresent:", forControlEvents:.TouchUpInside)
        bb.sizeToFit()
        vc.navigationItem.titleView = bb
        //hmm, this feels like a bug: merely examining the presentation controller...
        //freezes it so that it never becomes a popover presentation controller
        //println(nav.presentationController)
        nav.modalPresentationStyle = .Popover
        //println(nav.presentationController)
        self.presentViewController(nav, animated: true, completion: nil)
        
        // where's the configuration for the popover controller?
        // we can do it _after_ presentation
        if let pop = nav.popoverPresentationController { // self-contained; no need to retain or track!
            pop.barButtonItem = sender as! UIBarButtonItem // who arrow points to
            pop.delegate = self
            // if you want to prevent toolbar buttons from being active
            // by setting passthroughViews to nil, you must use non-zero delayed performance
            // I find this annoying; why does the toolbar default to being active?
            delay(0.1) {
                pop.passthroughViews = nil
            }
            // just playing with appearance; try it with and without
        pop.backgroundColor = UIColor.yellowColor() // visible as arrow color
        }
        nav.navigationBar.barTintColor = UIColor.redColor() // works in iOS 8
        //nav.navigationBar.backgroundColor = UIColor.redColor()
        nav.navigationBar.tintColor = UIColor.whiteColor()
        
        nav.delegate = self // workaround for content size changing bug
    }
    
    // state saving and button dismissal; dismiss = dismiss presented view controller
    
    func cancelPop1(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().setInteger(self.oldChoice, forKey: "choice")
    }
    
    func savePop1(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // presented view controller inside popover; just use .CurrentContext
    
    func doPresent(sender:AnyObject) {
        // referring to the popover is now much easier!
        // also, note that automatic size adjustment now just works
        // this is because the popover controller is a UIContentContainer...
        // and can respond to preferred size changes from its child
        let evc = ExtraViewController(nibName: nil, bundle: nil)
        self.presentedViewController!.presentViewController(evc, animated: true, completion: nil)
    }
    
    // demonstrating how to summon a popover attached to an ordinary view
    // also, playing with the ability to move a popover from one source rect to another;
    // show the popover (lower right button) and then rotate the interface
    
    @IBAction func doButton(sender:AnyObject) {
        let v = sender as! UIView
        let vc = UIViewController()
        vc.modalPresentationStyle = .Popover
        self.presentViewController(vc, animated: true, completion: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = v
            pop.sourceRect = v.bounds
            pop.delegate = self
            // not working here either
            pop.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 30)
        }
    }
    
    // second popover, demonstrating some additional configuration features
    
    @IBAction func doPopover2 (sender:AnyObject) {
        let vc = UIViewController()
        vc.modalPresentationStyle = .Popover
        // vc.modalInPopover = true
        self.presentViewController(vc, animated: true, completion: nil)
        // vc's view is now loaded and we are free to configure it further
        vc.view.frame = CGRectMake(0,0,300,300)
        vc.view.backgroundColor = UIColor.greenColor()
        vc.preferredContentSize = CGSizeMake(300,300)
        let label = UILabel()
        label.text = "I am a very silly popover!"
        label.sizeToFit()
        label.center = CGPointMake(150,150)
        label.frame = CGRectIntegral(label.frame)
        vc.view.addSubview(label)
        let t = UITapGestureRecognizer(target:self, action:"tapped:")
        vc.view.addGestureRecognizer(t)
        if let pop = vc.popoverPresentationController {
            // uncomment next line if you want there to be no way to dismiss!
            // vc.modalInPopover = true
            // we can dictate the background view
            pop.popoverBackgroundViewClass = MyPopoverBackgroundView.self
            pop.barButtonItem = sender as! UIBarButtonItem
            // we can force the popover further from the edge of the screen
            // silly example: just a little extra space at this popover's right
            // but it isn't working; this may be an iOS 8 bug
            pop.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 30)
            pop.delegate = self
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }
    
    func tapped (sender:AnyObject) {
        println("tap")
        let presenter = self.presentedViewController!
        presenter.modalInPopover = true // no effect
        let vc = UIViewController()
        vc.modalInPopover = true // no effect
        vc.modalPresentationStyle = .CurrentContext // oooh
        vc.view.frame = CGRectMake(0,0,300,300)
        vc.view.backgroundColor = UIColor.whiteColor()
        vc.preferredContentSize = vc.view.bounds.size
        let b = UIButton.buttonWithType(.System) as! UIButton
        b.setTitle("Done", forState:.Normal)
        b.sizeToFit()
        b.center = CGPointMake(150,150)
        b.frame = b.frame.integerRect
        b.autoresizingMask = .None
        b.addTarget(self, action:"done:", forControlEvents:.TouchUpInside)
        vc.view.addSubview(b)
        // uncomment next line if you'd like to experiment
        // previously, only coverVertical was legal, but in iOS this restriction is lifted
        vc.modalTransitionStyle = .FlipHorizontal // wow, this looks really cool
        presenter.presentViewController(vc, animated:true, completion:{
                _ in println("presented")
            })
        //vc.modalInPopover = true // no effect
        delay(1) {
            // change in iOS 8.3!
            // I was trying to show that even though presented-in-popover v.c. _is_ modal in popover...
            // ... this has no effect: tapping outside dismisses _both_, including the popover
            // that was in iOS 8.1 (and 8.2?), but this is no longer true in 8.3
            // what happens now is that, as in iOS 7, presented-in-popover v.c. is modal once again
            // tapping outside the popover dismisses the presented-in-popover v.c.
            // but _not_ the popover itself
            // more about this in a later example
            println(presenter.popoverPresentationController!.passthroughViews)
            println(vc.modalInPopover)
        }
    }
    
    func done (sender:AnyObject) {
        var r = sender as! UIResponder
        do { r = r.nextResponder()! } while !(r is UIViewController)
        (r as! UIViewController).dismissViewControllerAnimated(true, completion: {
            println("dismissed")
            })
    }
}

extension ViewController : UINavigationControllerDelegate {
    // deal with content size change bug
    // this bug is evident when you tap the Change Size row and navigate back:
    // the height doesn't change back

    func navigationController(nc: UINavigationController, didShowViewController vc: UIViewController, animated: Bool) {
        nc.preferredContentSize = vc.preferredContentSize
    }

}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func prepareForPopoverPresentation(pop: UIPopoverPresentationController) {
        if pop.presentedViewController is UINavigationController {
            // this is a popover where the user can make changes but then cancel them
            // thus we need to preserve the current values in case we have to revert (cancel) later
            self.oldChoice = NSUserDefaults.standardUserDefaults().integerForKey("choice")
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(pop: UIPopoverPresentationController) {
        if pop.presentedViewController is UINavigationController {
            // user cancelled, restore defaults
            NSUserDefaults.standardUserDefaults().setInteger(self.oldChoice, forKey: "choice")
        }
    }
    
    func popoverPresentationController(popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>, inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
        // just playing (also, note how to talk thru pointer parameter in Swift)
        println("reposition")
        if view.memory == self.button {
            rect.memory = self.button2.bounds
            view.memory = self.button2
        }
    }
    
    // uncomment to prevent tap outside present-in-popover from dismissing presented controller
    
    func popoverPresentationControllerShouldDismissPopover(
        pop: UIPopoverPresentationController) -> Bool {
            let ok = pop.presentedViewController.presentedViewController == nil
            return ok
    }


}

// new Xcode 6 feature; we are the toolbar's delegate in the storyboard
// in Xcode 5 you couldn't do that; you had to arrange it in code

extension ViewController : UIToolbarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
