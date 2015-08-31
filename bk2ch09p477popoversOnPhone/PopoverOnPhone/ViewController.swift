

import UIKit

class ViewController: UIViewController {
                            
    @IBAction func doButton(sender: AnyObject) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSizeMake(400,500)
        vc.modalPresentationStyle = .Popover
        
        // declare the delegate _before_ presentation!
        if let pres = vc.presentationController {
            pres.delegate = self // comment out to see what the defaults are
        }

        self.presentViewController(vc, animated: true, completion: nil)

        let wv = UIWebView()
        wv.backgroundColor = UIColor.whiteColor()
        vc.view.addSubview(wv)
        wv.frame = vc.view.bounds
        wv.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        let f = NSBundle.mainBundle().pathForResource("linkhelp", ofType: "html")
        let s = try! String(contentsOfFile: f!, encoding: NSUTF8StringEncoding)
        wv.loadHTMLString(s, baseURL: nil)
        
        if let pop = vc.popoverPresentationController {
            print(pop)
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
            pop.backgroundColor = UIColor.whiteColor()
        }
        
        // that alone is completely sufficient, on iOS 8, for iPad and iPhone!
        // on iPhone the v.c. will be modal fullscreen by default
        // thus there is no need for conditional code about what device this is!
        
        // however, there's no way to dismiss the fullscreen web view on iPhone
        // the way we take care of this is thru the popover presentation controller's delegate
        // it substitutes a different view controller with a Done button
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    // UIPopoverPresentationControllerDelegate conforms to UIAdaptivePresentationControllerDelegate
    
    // no need to call this any longer, though you can if you want to
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.horizontalSizeClass == .Compact {
            // return .None // permitted not to adapt even on iPhone
            // return .FormSheet // can also cover partially on iPhone
            return .FullScreen
        }
        // return .FullScreen // permitted to adapt even on iPad
        // return .FormSheet // can adapt to anything
        return .None
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        // we actually get the chance to swap out the v.c. for another!
        if style != .Popover {
            let vc = controller.presentedViewController
            let nav = UINavigationController(rootViewController: vc)
            let b = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissHelp:")
            vc.navigationItem.rightBarButtonItem = b
            return nav
        }
        return nil
    }
    
    func dismissHelp(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

