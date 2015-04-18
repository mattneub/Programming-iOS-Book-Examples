

import UIKit

// all greatly changed in iOS 8 and much for the better in my humble opinion

class ViewController: UIViewController {
    
    var alertString = ""
    
    @IBAction func doAlertView(sender:AnyObject) {
        let alert = UIAlertController(title: "Not So Fast!",
            message: "Do you really want to do this " +
            "tremendously destructive thing?",
            preferredStyle: .Alert)
        // no delegate needed merely to catch which button was tapped;
        // a UIAlertAction has a handler
        // here's a general handler (though none is needed if you want to ignore)
        func handler(act:UIAlertAction!) {
            println("User tapped \(act.title)")
        }
        // illustrating the three button styles
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "Maybe", style: .Default, handler: handler))
        // the last default one is bold in any case
        self.presentViewController(alert, animated: true, completion: nil)
        // dismissal is automatic when a button is tapped
    }
    
    // =====
    
    @IBAction func doAlertView2(sender:AnyObject) {
        let alert = UIAlertController(title: "Enter a number:", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler {
            (tf:UITextField!) in
            tf.keyboardType = .NumberPad
            tf.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
        }
        func handler(act:UIAlertAction!) {
            // it's a closure so we have a reference to the alert
            let tf = alert.textFields![0] as! UITextField
            println("User entered \(tf.text), tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: handler))
        (alert.actions[1] as! UIAlertAction).enabled = false
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textChanged(sender:AnyObject) {
        let tf = sender as! UITextField
        // enable OK button only if there is text
        // hold my beer and watch this: how to get a reference to the alert
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.nextResponder() }
        let alert = resp as! UIAlertController
        (alert.actions[1] as! UIAlertAction).enabled = (tf.text != "")
    }
    
    // =====
    
    func doActionSheet(sender:AnyObject) {
        let action = UIAlertController(title: "Choose New Layout", message: nil, preferredStyle: .ActionSheet)
        action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        func handler(act:UIAlertAction!) {
            println(act.title)
        }
        for s in ["3 by 3", "4 by 3", "4 by 4", "5 by 4", "5 by 5"] {
            action.addAction(UIAlertAction(title: s, style: .Default, handler: handler))
        }
        self.presentViewController(action, animated: true, completion: nil)
//        for v in self.view.subviews as [UIView] {
//            v.hidden = true
//        }
        if let pop = action.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }
}
