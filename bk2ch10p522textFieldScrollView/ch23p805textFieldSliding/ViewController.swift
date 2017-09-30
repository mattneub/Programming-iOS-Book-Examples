

import UIKit

class ViewController: UIViewController {
    @IBOutlet var scrollView : UIScrollView!
    // var fr : UIView?
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
        // content view's width and height constraints in storyboard are placeholders
        let contentView = self.scrollView.subviews[0]
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo:self.scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo:self.scrollView.heightAnchor),
        ])
        
        self.scrollView.keyboardDismissMode = .interactive
        
    }
    
//    func textFieldDidBeginEditing(tf: UITextField) {
//        self.fr = tf // keep track of first responder
//    }
    
    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        print("return")
        // self.fr = nil
        tf.resignFirstResponder()
        return true
    }
    
    override var shouldAutorotate : Bool {
        return !self.keyboardShowing
    }

    @objc func keyboardShow(_ n:Notification) {
        if self.keyboardShowing {
            return
        }
        self.keyboardShowing = true
        
        print("show")

        self.oldContentInset = self.scrollView.contentInset
        self.oldIndicatorInset = self.scrollView.scrollIndicatorInsets
        self.oldOffset = self.scrollView.contentOffset
        
        let d = n.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        r = self.scrollView.convert(r, from:nil)
        // no need to scroll, as the scroll view will do it for us
        // so all we have to do is adjust the inset
        self.scrollView.contentInset.bottom = r.size.height
        self.scrollView.scrollIndicatorInsets.bottom = r.size.height
        
    }
    
    @objc func keyboardHide(_ n:Notification) {
        if !self.keyboardShowing {
            return
        }
        self.keyboardShowing = false

        print("hide")
//        do { // work around bug
//            let d = n.userInfo!
//            let beginning = d[UIKeyboardFrameBeginUserInfoKey] as! CGRect
//            let ending = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
//            if beginning == ending {print("bail!"); return}
//        }
        self.scrollView.contentOffset = self.oldOffset
        self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
        self.scrollView.contentInset = self.oldContentInset
//        self.fr?.resignFirstResponder()
//        self.fr = nil

    }

    
    
}
