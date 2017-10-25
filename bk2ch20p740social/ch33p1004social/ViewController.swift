

import UIKit
import MessageUI
import Social

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBAction func doMail (_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            print("no mail")
            return
        }
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        self.present(vc, animated:true)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("mail result: \(result.rawValue)")
        self.dismiss(animated:true)
    }
    
    // ================
    
    @IBAction func doMessage (_ sender: Any) {
        guard MFMessageComposeViewController.canSendText() else {
            print("no messages") // but this won't happen even if messages are not configured
            return
        }
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = self
        self.present(vc, animated:true)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("message result: \(result.rawValue)")
        self.dismiss(animated:true)
    }
    
    // ================
    
    // deprecated in iOS 11? I think I'll omit it in any case, just to be on the safe side
    
    @IBAction func doTwitter (_ sender: Any!) {
        guard SLComposeViewController.isAvailable(forServiceType:SLServiceTypeTwitter) else {
            print("no tweeting") // e.g. user isn't signed up
            return
        }
        guard let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter) else {
            return
        }
        vc.completionHandler = { result in // SLComposeViewControllerResult
            print("tweet result \(result.rawValue)")
            self.dismiss(animated:true)
        };
        self.present(vc, animated:true)
    }
    

}
