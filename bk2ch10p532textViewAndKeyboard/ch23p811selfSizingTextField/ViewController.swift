
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
        let s = try! String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
        let s2 = s.stringByReplacingOccurrencesOfString("\n", withString: "")
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
        
        self.tv.keyboardDismissMode = .Interactive

    }
    
    override func shouldAutorotate() -> Bool {
        return !self.keyboardShowing
    }
    
    // as long as you play your part (adjust content offset),
    // iOS 8 will play its part (scroll cursor to visible)
    // and we don't have to animate
    
    func keyboardShow(n:NSNotification) {
        print("show")
        
        let d = n.userInfo!
        var r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        r = self.tv.convertRect(r, fromView:nil)
        self.tv.contentInset.bottom = r.size.height
        self.tv.scrollIndicatorInsets.bottom = r.size.height
        
        self.keyboardShowing = true
        

    }
    
    func keyboardHide(n:NSNotification) {
        print("hide")
        
        self.tv.contentInset = UIEdgeInsetsZero
        self.tv.scrollIndicatorInsets = UIEdgeInsetsZero
        
        self.keyboardShowing = false

    }

    func doDone(sender:AnyObject) {
        self.view.endEditing(false)
    }

}
