

import UIKit
import MessageUI
import Social

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBAction func doMail (sender:AnyObject!) {
        let ok = MFMailComposeViewController.canSendMail()
        if !ok {
            println("no mail")
            return
        }
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        self.presentViewController(vc, animated:true, completion:nil)
    }

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        println("mail result: \(result.value)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ================
    
    @IBAction func doMessage (sender:AnyObject!) {
        let ok = MFMessageComposeViewController.canSendText()
        if !ok {
            println("no messages") // but this won't happen even if messages are not configured
            return
        }
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = self
        self.presentViewController(vc, animated:true, completion:nil)
    }

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        println("message result: \(result.value)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ================
    
    @IBAction func doTwitter (sender:AnyObject!) {
        let ok = SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
        if !ok {
            println("no tweeting") // e.g. user isn't signed up
            return
        }
        let vc : SLComposeViewController! = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        if vc == nil {
            return
        }
        vc.completionHandler = {
            (result:SLComposeViewControllerResult) in
            println("tweet result \(result.rawValue)")
            self.dismissViewControllerAnimated(true, completion:nil)
        };
        self.presentViewController(vc, animated:true, completion:nil)
    }
    
    // =============
    
    @IBAction func doShare (sender:AnyObject!) {
        let act = UIActivityViewController(activityItems: ["Hello, world!"], applicationActivities: nil)
        act.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            println("completed \(s) \(ok) \(items) \(err)")
        }
        self.presentViewController(act, animated: true, completion: nil)
        if let pop = act.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }
    
    /*
    I include this approach because, new in iOS 8, you can create a Share Extension
    to be included among the possibilities in the first row (i.e. along with Mail and Message)
*/



}
