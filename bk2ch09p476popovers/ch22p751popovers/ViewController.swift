
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController : UIViewController {
    @IBOutlet var button : UIButton!
    @IBOutlet var button2 : UIButton!
    var oldChoice : Int = -1
    
    // popover handling is completely revised in iOS 8 (at last!)
    // a popover is a form of presented view controller...
    // ...and to configure/modify it,
    // you use the popover presentation controller and act as its delegate
    
    @IBAction func doPopover1(_ sender: Any?) {
        let vc = Popover1View1()
        // vc.isModalInPopover = true
        let nav = UINavigationController(rootViewController: vc)
        let b = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
            action: #selector(cancelPop1))
        vc.navigationItem.rightBarButtonItem = b
        let b2 = UIBarButtonItem(barButtonSystemItem: .done, target: self,
            action: #selector(savePop1))
        vc.navigationItem.leftBarButtonItem = b2
        let bb = UIButton(type:.infoDark)
        bb.addTarget(self, action:#selector(doPresent), for:.touchUpInside)
        bb.sizeToFit()
        vc.navigationItem.titleView = bb
        //hmm, this feels like a bug: merely examining the presentation controller...
        //freezes it so that it never becomes a popover presentation controller!
        //print(nav.presentationController)
        nav.modalPresentationStyle = .popover
        print(nav.presentationController as Any)
        print(nav.popoverPresentationController as Any)
        self.present(nav, animated: true) {
            // if you want to prevent toolbar buttons from being active
            // by setting passthroughViews to nil, you must do it after presentation is complete
            // I find this annoying; why does the toolbar default to being active?
            nav.popoverPresentationController?.passthroughViews = nil
        }
        
        // where's the configuration for the popover controller?
        // we can do it _after_ presentation
        if let pop = nav.popoverPresentationController { // self-contained; no need to retain or track!
            pop.barButtonItem = sender as? UIBarButtonItem // who arrow points to
            pop.delegate = self
            // just playing with appearance; try it with and without
            pop.backgroundColor = .yellow // visible as arrow color
            // pop.passthroughViews = nil
        }
        nav.navigationBar.barTintColor = .red // works in iOS 8
        //nav.navigationBar.backgroundColor = .red
        nav.navigationBar.tintColor = .white
        
        nav.delegate = self // workaround for content size changing bug
    }
    
    // state saving and button dismissal; dismiss = dismiss presented view controller
    
    @objc func cancelPop1(_ sender: Any) {
        self.dismiss(animated:true)
        UserDefaults.standard.set(self.oldChoice, forKey: "choice")
    }
    
    @objc func savePop1(_ sender: Any) {
        self.dismiss(animated:true)
    }
    
    // presented view controller inside popover; just use .CurrentContext
    
    @objc func doPresent(_ sender: Any) {
        // referring to the popover is now much easier!
        // also, note that automatic size adjustment now just works
        // this is because the popover controller is a UIContentContainer...
        // and can respond to preferred size changes from its child
        let evc = ExtraViewController(nibName: nil, bundle: nil)
        self.presentedViewController!.present(evc, animated: true)
    }
    
    // demonstrating how to summon a popover attached to an ordinary view
    // also, playing with the ability to move a popover from one source rect to another;
    // show the popover (lower right button) and then rotate the interface
    
    @IBAction func doButton(_ sender: Any) {
        let v = sender as! UIView
        let vc = UIViewController()
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = v
            pop.sourceRect = v.bounds
            pop.delegate = self
            // not working here either
            pop.popoverLayoutMargins = UIEdgeInsets(top: 100,left: 100,bottom: 100,right: 100)
            // new in iOS 9
            pop.canOverlapSourceViewRect = true // default is false
            
            vc.preferredContentSize = CGSize(200,500)

        }
    }
    
    // second popover, demonstrating some additional configuration features
    
    @IBAction func doPopover2 (_ sender: Any) {
        let vc = UIViewController()
        vc.modalPresentationStyle = .popover
        // vc.isModalInPopover = true
        print(vc.popoverPresentationController as Any) // NB valid here, we could configure here
        
        self.present(vc, animated: true) {
            vc.popoverPresentationController?.passthroughViews = nil
        }
        // vc's view is now loaded and we are free to configure it further
        vc.view.frame = CGRect(0,0,300,300)
        vc.view.backgroundColor = .green
        vc.preferredContentSize = CGSize(300,300)
        let label = UILabel()
        label.text = "I am a very silly popover!"
        label.sizeToFit()
        label.center = CGPoint(150,150)
        label.frame = label.frame.integral
        vc.view.addSubview(label)
        let t = UITapGestureRecognizer(target:self, action:#selector(tapped))
        vc.view.addGestureRecognizer(t)
        
        if let pop = vc.popoverPresentationController {
            print(pop)
            // uncomment next line if you want there to be no way to dismiss!
            // vc.isModalInPopover = true
            // we can dictate the background view
            pop.popoverBackgroundViewClass = MyPopoverBackgroundView.self
            pop.barButtonItem = sender as? UIBarButtonItem
            // we can force the popover further from the edge of the screen
            // silly example: just a little extra space at this popover's right
            // but it isn't working; this may be an iOS 8/9 bug
            pop.popoverLayoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            pop.delegate = self
        }

    }
    
    @objc func tapped (_ sender: Any) {
        print("tap")
        let vc = UIViewController()
        vc.modalPresentationStyle = .currentContext // oooh
        vc.view.frame = CGRect(0,0,300,300)
        vc.view.backgroundColor = .white
        vc.preferredContentSize = vc.view.bounds.size
        let b = UIButton(type:.system)
        b.setTitle("Done", for:.normal)
        b.sizeToFit()
        b.center = CGPoint(150,150)
        b.frame = b.frame.integral
        b.autoresizingMask = [] // none
        b.addTarget(self, action:#selector(done), for:.touchUpInside)
        vc.view.addSubview(b)
        // uncomment next line if you'd like to experiment
        // previously, only coverVertical was legal, but this restriction is lifted
        vc.modalTransitionStyle = .flipHorizontal // wow, this looks really cool
        
        let presenter = self.presentedViewController!
        presenter.present(vc, animated:true) {
            print("presented")
            
            // long-standing problem of how we want this to be dismissable
            // presenter.isModalInPopover = true // no, has no effect
            // vc.isModalInPopover = true // no, unnecessary: it now _will_ be modal!
            // (and in fact you can't prevent it)
        }
        
        // change in iOS 8.3!
        // I was trying to show that even though presented-in-popover v.c. _is_ modal in popover...
        // ... this has no effect: tapping outside dismisses _both_, including the popover
        // that was in iOS 8.1 (and 8.2?), but this is no longer true in 8.3
        // what happens now is that, as in iOS 7, presented-in-popover v.c. is modal once again
        // tapping outside the popover dismisses the presented-in-popover v.c.
        // but _not_ the popover itself
        // more about this in a later example
        
        // changed again in iOS 9?! 
        // Now we are back to the way it was in 8.1: tapping outside dismisses both
        // I'm working around this with `shouldDismiss`, below
        
    }
    
    @objc func done (_ sender:UIResponder) {
        var r : UIResponder! = sender
        repeat { r = r.next } while !(r is UIViewController)
        (r as! UIViewController).dismiss(animated:true) {
            print("dismissed")
        }
    }
}

extension ViewController : UINavigationControllerDelegate {
    // deal with content size change bug
    // this bug is evident when you tap the Change Size row and navigate back:
    // the height doesn't change back

    func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        nc.preferredContentSize = vc.preferredContentSize
    }

}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func prepareForPopoverPresentation(_ pop: UIPopoverPresentationController) {
        if pop.presentedViewController is UINavigationController {
            // this is a popover where the user can make changes but then cancel them
            // thus we need to preserve the current values in case we have to revert (cancel) later
            self.oldChoice = UserDefaults.standard.integer(forKey:"choice")
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ pop: UIPopoverPresentationController) {
        if pop.presentedViewController is UINavigationController {
            // user cancelled, restore defaults
            UserDefaults.standard.set(self.oldChoice, forKey: "choice")
        }
    }
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        // just playing (also, note how to talk thru pointer parameter in Swift)
        print("reposition")
        if view.pointee == self.button {
            rect.pointee = self.button2.bounds
            view.pointee = self.button2
        }
    }
    
    // uncomment to prevent tap outside present-in-popover from dismissing presented controller
    
    func popoverPresentationControllerShouldDismissPopover(
        _ pop: UIPopoverPresentationController) -> Bool {
            return pop.presentedViewController.presentedViewController == nil
    }


}

// new Xcode 6 feature; we are the toolbar's delegate in the storyboard
// in Xcode 5 you couldn't do that; you had to arrange it in code

extension ViewController : UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
