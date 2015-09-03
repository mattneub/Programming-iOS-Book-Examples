

import UIKit

class ViewController: UIViewController {
    @IBOutlet var scrollView : UIScrollView!
    // var fr : UIView?
    var oldContentInset = UIEdgeInsetsZero
    var oldIndicatorInset = UIEdgeInsetsZero
    var oldOffset = CGPointZero
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let contentView = self.scrollView.subviews[0]
        NSLayoutConstraint.activateConstraints([
            contentView.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor),
            contentView.heightAnchor.constraintEqualToAnchor(self.scrollView.heightAnchor),
        ])
        
        self.scrollView.keyboardDismissMode = .Interactive
        
    }
    
//    func textFieldDidBeginEditing(tf: UITextField) {
//        self.fr = tf // keep track of first responder
//    }
    
    func textFieldShouldReturn(tf: UITextField) -> Bool {
        print("return")
        tf.resignFirstResponder()
        // self.fr = nil
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return !self.keyboardShowing
    }

    func keyboardShow(n:NSNotification) {
        self.oldContentInset = self.scrollView.contentInset
        self.oldIndicatorInset = self.scrollView.scrollIndicatorInsets
        self.oldOffset = self.scrollView.contentOffset
        
        let d = n.userInfo!
        var r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        r = self.scrollView.convertRect(r, fromView:nil)
        // no need to scroll, as the scroll view will do it for us
        // so all we have to do is adjust the inset
        self.scrollView.contentInset.bottom = r.size.height
        self.scrollView.scrollIndicatorInsets.bottom = r.size.height
        
        self.keyboardShowing = true
    }
    
    func keyboardHide(n:NSNotification) {
        print("hide")
        self.scrollView.bounds.origin = self.oldOffset
        self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
        self.scrollView.contentInset = self.oldContentInset
//        self.fr?.resignFirstResponder()
//        self.fr = nil
        
        self.keyboardShowing = false

    }

    
    
}
