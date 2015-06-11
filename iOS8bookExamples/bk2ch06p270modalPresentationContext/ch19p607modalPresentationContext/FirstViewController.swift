
import UIKit

class FirstViewController : UIViewController {
    
    @IBAction func doPresent(sender:AnyObject?) {
        let which = 1
        switch which {
        case 1:
            let vc = ExtraViewController(nibName: "ExtraViewController", bundle: nil)
            self.presentViewController(vc, animated: true, completion: nil)
            
        case 2:
            // in iOS 8, this works on iPhone as well as iPad!
            // presented vc appears over first vc *inside* tabbed interface
            let vc = ExtraViewController(nibName: "ExtraViewController", bundle: nil)
            self.definesPresentationContext = true
            vc.modalPresentationStyle = .CurrentContext
            self.presentViewController(vc, animated: true, completion: nil)

        case 3:
            let vc = ExtraViewController(nibName: "ExtraViewController", bundle: nil)
            
            self.definesPresentationContext = true
            // comment out next line to see the difference
            self.providesPresentationContextTransitionStyle = true
            self.modalTransitionStyle = .CoverVertical
            vc.modalPresentationStyle = .CurrentContext
            vc.modalTransitionStyle = .FlipHorizontal // this will be overridden
            
            vc.modalPresentationCapturesStatusBarAppearance = true
            
            self.presentViewController(vc, animated: true, completion: nil)

            /*
            cases 2 and 3 also demonstrate a nasty bug
            to see it:
            start in First view, tap button to present
            switch to Second view
            switch back to First view, tap button to dismiss
            black view, that's the bug
    */
            
            
        default: break
        }
    }
}
