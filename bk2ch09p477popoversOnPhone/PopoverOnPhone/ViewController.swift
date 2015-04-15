

import UIKit

class ViewController: UIViewController {
                            
    @IBAction func doButton(sender: AnyObject) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSizeMake(400,500)
        vc.modalPresentationStyle = .Popover
        
        // trick #1; declare the delegate _before_ presentation!
        if let pres = vc.popoverPresentationController {
            pres.delegate = self
        }

        self.presentViewController(vc, animated: true, completion: nil)

        let wv = UIWebView()
        vc.view.addSubview(wv)
        wv.frame = vc.view.bounds
        wv.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        let f = NSBundle.mainBundle().pathForResource("linkhelp", ofType: "html")
        let s = String(contentsOfFile: f!, encoding: NSUTF8StringEncoding, error: nil)
        wv.loadHTMLString(s, baseURL: nil)
        
        if let pop = vc.popoverPresentationController {
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
        }
        
        // that alone is completely sufficient, on iOS 8, for iPad and iPhone!
        // on iPhone the v.c. will be modal fullscreen by default
        // thus there is no need for conditional code about what device this is!
        
        // however, there's no way to dismiss the web view on iPhone
        // the way we take care of this is thru the popover presentation controller's delegate
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    // UIPopoverPresentationControllerDelegate conforms to UIAdaptivePresentationControllerDelegate
    // on iPhone, a popover is considered adaptive!
    // therefore, the delegate is consulted
    
    // trick #2: implement this method even if you want the default...
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // we could do some sort of check here...
        // ...but the important thing is: we won't even be consulted except in an "adaptive" situation
        // i.e. it's not an iPad
        return .FullScreen
        //return .None
    }
    
    // trick #3: fix the interface for iPhone, but this won't be called
    // unless you did trick #2 and returned .FullScreen (or .OverFullScreen)
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        // we actually get the chance to swap out the v.c. for another!
        // again, we could do a check here...
        // ... but one thing is for sure: this must be a fullscreen iPhone presentation
        let vc = controller.presentedViewController
        let nav = UINavigationController(rootViewController: vc)
        let b = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissHelp:")
        vc.navigationItem.rightBarButtonItem = b
        return nav
    }
    
    func dismissHelp(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    Was that cool or what? But wait, there's more!
    Return .None from the first method instead of .FullScreen, and you get
    an actual bona fide pointy-arrowed popover right on the iPhone - for the first time in history!
*/
    
}

