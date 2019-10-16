

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var tv : UITextView!
    @IBOutlet var heightConstraint : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tv.isScrollEnabled = false // *
        self.heightConstraint.isActive = false // *
        
        let s = """
            Twas brillig, and the slithy toves did gyre and gimble in the wabe; \
            all mimsy were the borogoves, and the mome raths outgrabe.
            """
        let mas = NSMutableAttributedString(string:s, attributes:[
            .font: UIFont(name:"GillSans", size:20)!
        ])
        
        mas.addAttribute(.paragraphStyle,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .left
                para.lineBreakMode = .byWordWrapping
            }, range:NSMakeRange(0,1))
        
        self.tv.attributedText = mas
        
    }
    
    override func viewDidLayoutSubviews() {
        let h = self.tv.contentSize.height
        let limit : CGFloat = 200 // or whatever
        if h > limit && !self.tv.isScrollEnabled {
            self.tv.isScrollEnabled = true
            self.heightConstraint.constant = limit
            self.heightConstraint.isActive = true
        } else if h < limit && self.tv.isScrollEnabled {
            self.tv.isScrollEnabled = false
            self.heightConstraint.isActive = false
        }
    }

}
