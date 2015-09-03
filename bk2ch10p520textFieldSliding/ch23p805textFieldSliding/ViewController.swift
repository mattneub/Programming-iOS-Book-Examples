
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
        print("did begin!")
        self.fr = tf // keep track of first responder
        
//        let s = NSAttributedString(string: "this is a test", attributes: [NSForegroundColorAttributeName:UIColor.blueColor(), NSFontAttributeName:UIFont(name: "GillSans", size: 20)!])
//        tf.attributedText = s
//        tf.textColor = UIColor.redColor()
//        tf.text = "howdy"
//        print(tf.attributedText)
//        
//        let lab = UILabel()
//        lab.attributedText = s
//        lab.textColor = UIColor.redColor()
//        lab.text = "howdy"
//        print(lab.attributedText)
        
//        let s = NSAttributedString(string: "this is a test so let's see what happens when we do this", attributes: [NSForegroundColorAttributeName:UIColor.blueColor(), NSFontAttributeName:UIFont(name: "GillSans", size: 20)!])
//        tf.adjustsFontSizeToFitWidth = false
//        tf.minimumFontSize = 6
//        tf.attributedPlaceholder = s
        
        // tf.borderStyle = .Bezel
        // tf.backgroundColor = UIColor.redColor()
        
//        let t = UITextField()
//        t.borderStyle = .RoundedRect
//        t.text = "This is a test of what is going on"
//        t.sizeToFit()
//        self.view.addSubview(t)
        
//        tf.background = UIImage(named:"yellowsilk4")!
//        tf.borderStyle = .Line

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
        print("show!")
        let d = n.userInfo!
        if let local = d[UIKeyboardIsLocalUserInfoKey] {
            print(local)
        }
        var r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        r = self.slidingView.convertRect(r, fromView:nil)
        if let f = self.fr?.frame {
            let y : CGFloat =
                f.maxY + r.size.height - self.slidingView.bounds.height + 5
            if r.origin.y < f.maxY {
                self.topConstraint.constant = -y
                self.bottomConstraint.constant = y
                self.view.layoutIfNeeded()
            }
        }
    }

    func keyboardHide(n:NSNotification) {
        print("hide!")
        let d = n.userInfo!
        if let local = d[UIKeyboardIsLocalUserInfoKey] {
            print(local)
        }
        self.topConstraint.constant = 0
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        self.fr?.resignFirstResponder()
        self.fr = nil
    }

}
