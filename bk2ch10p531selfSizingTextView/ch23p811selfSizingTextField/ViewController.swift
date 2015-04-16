

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
            self.adjustHeight()
        }
        
    }
    
    func adjustHeight() {
        let sz = self.tv.sizeThatFits(CGSizeMake(self.tv.bounds.width, 10000))
        self.heightConstraint.constant = ceil(sz.height)
    }
    
    // kind of hacky, but the problem is that textViewDidChange was happening too late;
    // by that time, the text view had scrolled if necessary

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        textView.text = (textView.text as NSString).stringByReplacingCharactersInRange(range,
            withString:text)
        self.adjustHeight()
        return false
    }
    
    /*
    // old code:
    
    -(void)textViewDidChange:(UITextView *)textView {
    // [textView sizeToFit]; // seems no longer needed in iOS 7.1
    self.heightConstraint.constant = textView.contentSize.height;
    }

*/
    
}
