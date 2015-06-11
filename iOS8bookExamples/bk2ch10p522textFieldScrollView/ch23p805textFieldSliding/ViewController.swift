

import UIKit

class ViewController: UIViewController {
    @IBOutlet var scrollView : UIScrollView!
    var fr : UIView?
    var oldContentInset = UIEdgeInsetsZero
    var oldIndicatorInset = UIEdgeInsetsZero
    var oldOffset = CGPointZero

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let contentView = self.scrollView.subviews[0] as! UIView
        self.scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: self.scrollView, attribute: .Height, multiplier: 1, constant: 0))
        
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
    }
    
    func keyboardHide(n:NSNotification) {
        self.scrollView.bounds.origin = self.oldOffset
        self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
        self.scrollView.contentInset = self.oldContentInset
    }

    
    
}
