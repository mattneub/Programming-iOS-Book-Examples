

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var tv : UITextView!
    @IBOutlet var heightConstraint : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        let s = "Twas brillig, and the slithy toves did gyre and gimble in the wabe; " +
            "all mimsy were the borogoves, and the mome raths outgrabe."
        
        let mas = NSMutableAttributedString(string:s, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
        ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .Left
                para.lineBreakMode = .ByWordWrapping
            }, range:NSMakeRange(0,1))
        
        self.tv.attributedText = mas
        
        dispatch_async(dispatch_get_main_queue()) {
            self.adjustHeight(self.tv)
        }
        
    }
    
    func adjustHeight(tv:UITextView) {
//        let sz = self.tv.sizeThatFits(CGSizeMake(self.tv.bounds.width, 10000))
//        self.heightConstraint.constant = ceil(sz.height)
        self.heightConstraint.constant = ceil(tv.contentSize.height)
    }
    
//    func textViewDidChange(textView: UITextView) {
//        delay(0.05) {
//            self.adjustHeight(textView)
//        }
//    }
    
    // textViewDidChange is happening too late;
    // by that time, the text view has scrolled if necessary
    // hence the delay
    // so I prefer a solution using shouldChangeTextInRange but the problem is...
    // if I return false, I also end up shifting the selection in weird ways
    // and then I have to put it back, and it's not obvious what the algorithm is
    // this is my attempt to get it right

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let sel = textView.selectedRange
        textView.text = (textView.text as NSString).stringByReplacingCharactersInRange(range,
            withString:text)
        self.adjustHeight(textView)
        textView.selectedRange =
            text.isEmpty && sel.length == 0 ?
                NSMakeRange(sel.location - 1,0) : NSMakeRange(sel.location + text.utf16.count, 0)
        return false
    }
    
    
}
