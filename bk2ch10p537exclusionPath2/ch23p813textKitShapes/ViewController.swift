

import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController {
    @IBOutlet var tv : UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("brillig", ofType: "txt")!
        let s = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
        let s2 = s!.stringByReplacingOccurrencesOfString("\n", withString: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:14)!
            ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .Left
                para.lineBreakMode = .ByCharWrapping
                para.hyphenationFactor = 1
            },
            range:NSMakeRange(0,1))
        
        let r = self.tv.frame
        let lm = NSLayoutManager()
        let ts = NSTextStorage()
        ts.addLayoutManager(lm)
        let tc = MyTextContainer(size:CGSizeMake(r.width, r.height))
        lm.addTextContainer(tc)
        let tv = UITextView(frame:r, textContainer:tc)
        
        self.tv.removeFromSuperview()
        self.view.addSubview(tv)
        self.tv = tv
        
        self.tv.attributedText = mas
        self.tv.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2)
        self.tv.scrollEnabled = false
        self.tv.backgroundColor = UIColor.yellowColor()

    }

}
