

import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController {
    
    @IBOutlet var tv : UITextView!
    @IBOutlet var tv2 : UITextView!
    var lm : NSLayoutManager!
    var ts : NSTextStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("brillig", ofType: "txt")!
        let s = try! String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
        let s2 = s.stringByReplacingOccurrencesOfString("\n", withString: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:14)!
            ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .Left
                para.lineBreakMode = .ByWordWrapping
                para.hyphenationFactor = 1
            },
            range:NSMakeRange(0,1))
        
        var which : Int { return 2 }
        switch which {
        case 1:
            
            let r = self.tv.frame
            let r2 = self.tv2.frame
            
            let ts1 = NSTextStorage(attributedString:mas)
            let lm1 = NSLayoutManager()
            ts1.addLayoutManager(lm1)
            let tc1 = NSTextContainer(size:r.size)
            lm1.addTextContainer(tc1)
            let tv = UITextView(frame:r, textContainer:tc1)
//            tv.scrollEnabled = false
            
            let tc2 = NSTextContainer(size:r2.size)
            lm1.addTextContainer(tc2)
            let tv2 = UITextView(frame:r2, textContainer:tc2)
//            tv2.scrollEnabled = false
            
            self.tv.removeFromSuperview()
            self.tv2.removeFromSuperview()
            tv.backgroundColor = UIColor.yellowColor()
            tv2.backgroundColor = UIColor.yellowColor()
            self.view.addSubview(tv)
            self.view.addSubview(tv2)
            self.tv = tv
            self.tv2 = tv2
            
        case 2:
            let r = self.tv.frame
            let r2 = self.tv2.frame
            
            let ts1 = NSTextStorage(attributedString:mas)
            let lm1 = NSLayoutManager()
            ts1.addLayoutManager(lm1)
            let lm2 = NSLayoutManager()
            ts1.addLayoutManager(lm2)
            
            let tc1 = NSTextContainer(size:r.size)
            let tc2 = NSTextContainer(size:r2.size)
            lm1.addTextContainer(tc1)
            lm2.addTextContainer(tc2)
            
            let tv = UITextView(frame:r, textContainer:tc1)
            let tv2 = UITextView(frame:r2, textContainer:tc2)

            self.tv.removeFromSuperview()
            self.tv2.removeFromSuperview()
            tv.backgroundColor = UIColor.yellowColor()
            tv2.backgroundColor = UIColor.yellowColor()
            self.view.addSubview(tv)
            self.view.addSubview(tv2)
            self.tv = tv
            self.tv2 = tv2

        default:break
        }
    }

}
