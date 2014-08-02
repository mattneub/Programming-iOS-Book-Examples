

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tv : UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("brillig", ofType: "txt")
        let s = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
        let s2 = s!.stringByReplacingOccurrencesOfString("\n", withString: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:14)
            ])
        
        let para = NSMutableParagraphStyle()
        para.alignment = .Left
        para.lineBreakMode = .ByCharWrapping
        para.hyphenationFactor = 1
        mas.addAttribute(NSParagraphStyleAttributeName, value:para, range:NSMakeRange(0,1))
        
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
