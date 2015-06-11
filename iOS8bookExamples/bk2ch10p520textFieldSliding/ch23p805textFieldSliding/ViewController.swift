
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var topConstraint : NSLayoutConstraint!
    @IBOutlet var bottomConstraint : NSLayoutConstraint!
    @IBOutlet var slidingView : UIView!
    var fr : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(tf: UITextField) {
        self.fr = tf // keep track of first responder
    }
    
    func textFieldShouldReturn(tf: UITextField) -> Bool {
        tf.resignFirstResponder()
        self.fr = nil
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return self.fr == nil
    }
    
    func keyboardShow(n:NSNotification) {
        let d = n.userInfo!
        var r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        // in iOS 8, keyboard and fullscreen views are in same coordinate space
        // however, I'm keeping this line because our view might not be fullscreen
        r = self.slidingView.convertRect(r, fromView:nil)
        let f = self.fr!.frame
        let y : CGFloat =
            f.maxY + r.size.height - self.slidingView.bounds.height + 5
        if r.origin.y < f.maxY {
            self.topConstraint.constant = -y
            self.bottomConstraint.constant = y
            self.view.layoutIfNeeded()
        }
    }

    func keyboardHide(n:NSNotification) {
        self.topConstraint.constant = 0
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }

}
