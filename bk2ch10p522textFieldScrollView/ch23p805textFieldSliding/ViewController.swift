

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
        
        // can't size content view this way on iOS 8
//        let contentView = self.scrollView.subviews[0] as UIView
//        self.scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1, constant: 0))
//        self.scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: self.scrollView, attribute: .Height, multiplier: 1, constant: 0))
        
    }
    
    func textFieldDidBeginEditing(tf: UITextField!) {
        self.fr = tf // keep track of first responder
    }
    
    func textFieldShouldReturn(tf: UITextField!) -> Bool {
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

        
        
        let d = n.userInfo
        var r = (d[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        // next line no longer needed; in iOS 8, keyboard and views are in same coordinate space
        r = self.scrollView.convertRect(r, fromView:nil)
        let f = self.fr!.frame
        let y : CGFloat =
        f.maxY + r.size.height - self.scrollView.bounds.height + 5
        let duration = d[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        let curve = d[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        let curveOpt = UIViewAnimationOptions.fromRaw(
            UInt(curve.unsignedIntegerValue) << 16)!
        
        if r.origin.y < f.maxY {
            UIView.animateWithDuration(duration.doubleValue,
                delay:0,
                options:curveOpt,
                animations:{
                    self.scrollView.bounds.origin = CGPointMake(0,y)
                    self.scrollView.contentInset.bottom = r.size.height
                    self.scrollView.scrollIndicatorInsets.bottom = r.size.height
                }, completion:nil)
        }
        

    }
    
    func keyboardHide(n:NSNotification) {
        let d = n.userInfo
        let duration = d[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        let curve = d[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        let curveOpt = UIViewAnimationOptions.fromRaw(
            UInt(curve.unsignedIntegerValue) << 16)!
        UIView.animateWithDuration(duration.doubleValue,
            delay:0,
            options:curveOpt,
            animations:{
                self.scrollView.bounds.origin = self.oldOffset
                self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
                self.scrollView.contentInset = self.oldContentInset
            }, completion:nil)
    }

    
    
}
