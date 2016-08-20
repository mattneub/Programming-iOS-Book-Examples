

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
                para.alignment = .left
                para.lineBreakMode = .byWordWrapping
            }, range:NSMakeRange(0,1))
        
        self.tv.attributedText = mas
        
        DispatchQueue.main.async {
            self.adjustHeight(self.tv)
        }
        
    }
    
    func adjustHeight(_ tv:UITextView) {
//        let sz = self.tv.sizeThatFits(CGSize(self.tv.bounds.width, 10000))
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

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let sel = textView.selectedRange
//        textView.text = (textView.text as NSString).replacingCharacters(in:range,
//            with:text)
        self.adjustHeight(textView)
//        textView.selectedRange =
//            text.isEmpty && sel.length == 0 ?
//                NSMakeRange(sel.location - 1,0) : NSMakeRange(sel.location + text.utf16.count, 0)
        return true
    }
    
    
}
