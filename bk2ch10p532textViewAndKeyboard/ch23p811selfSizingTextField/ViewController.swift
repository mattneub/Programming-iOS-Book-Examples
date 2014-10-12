
import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var tv : UITextView!
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().pathForResource("brillig", ofType: "txt")!
        let s = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
        let s2 = s!.stringByReplacingOccurrencesOfString("\n", withString: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
            ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .Left
                para.lineBreakMode = .ByWordWrapping
            },
            range:NSMakeRange(0,1))
        
        self.tv.attributedText = mas

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func shouldAutorotate() -> Bool {
        return !self.keyboardShowing
    }
    
    // much simpler than in iOS 7; a lot of the touchy bugs are gone in iOS 8
    // as long as you play your part (adjust content offset),
    // iOS 8 will play its part (scroll cursor to visible)
    
    func keyboardShow(n:NSNotification) {
        self.keyboardShowing = true
        
        let d = n.userInfo!
        var r = (d[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        r = self.tv.superview!.convertRect(r, fromView:nil)
//        let duration = d[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        let f = self.tv.frame
        let fs = self.tv.superview!.bounds
        let diff = fs.size.height - f.origin.y - f.size.height;
        let keyboardTop = r.size.height - diff
//        UIView.animateWithDuration(duration.doubleValue,
//            delay: 0, options: nil, animations: {
                self.tv.contentInset.bottom = keyboardTop
                self.tv.scrollIndicatorInsets.bottom = keyboardTop
//            }, completion: nil)
    }
    
    func keyboardHide(n:NSNotification) {
        self.keyboardShowing = false
        
//        let d = n.userInfo!
//        let duration = d[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
//        let curve = d[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
//        let curveOpt = UIViewAnimationOptions.fromRaw(
//            UInt(curve.unsignedIntegerValue) << 16)!
//        UIView.animateWithDuration(duration.doubleValue,
//            delay:0,
//            options:curveOpt,
//            animations:{
                self.tv.contentInset = UIEdgeInsetsZero
                self.tv.scrollIndicatorInsets = UIEdgeInsetsZero
//            }, completion:nil)
    }

    func doDone(sender:AnyObject) {
        self.view.endEditing(false)
    }

}
