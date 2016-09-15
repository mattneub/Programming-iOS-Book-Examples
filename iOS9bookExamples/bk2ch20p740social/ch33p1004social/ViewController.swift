

import UIKit
import MessageUI
import Social

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBAction func doMail (sender:AnyObject!) {
        guard MFMailComposeViewController.canSendMail() else {
            print("no mail")
            return
        }
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        self.presentViewController(vc, animated:true, completion:nil)
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print("mail result: \(result.rawValue)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ================
    
    @IBAction func doMessage (sender:AnyObject!) {
        guard MFMessageComposeViewController.canSendText() else {
            print("no messages") // but this won't happen even if messages are not configured
            return
        }
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = self
        self.presentViewController(vc, animated:true, completion:nil)
    }

    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        print("message result: \(result.rawValue)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ================
    
    @IBAction func doTwitter (sender:AnyObject!) {
        guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) else {
            print("no tweeting") // e.g. user isn't signed up
            return
        }
        guard let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter) else {
            return
        }
        vc.completionHandler = {
            (result:SLComposeViewControllerResult) in
            print("tweet result \(result.rawValue)")
            self.dismissViewControllerAnimated(true, completion:nil)
        };
        self.presentViewController(vc, animated:true, completion:nil)
    }
    

}
