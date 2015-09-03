

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
        
        self.tv.attributedText = mas
        
        self.tv.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 0)
        self.tv.scrollEnabled = false

    }
    
    override func viewDidLayoutSubviews() {
        let sz = self.tv.textContainer.size
        let p = UIBezierPath()
        p.moveToPoint(CGPointMake(sz.width/4.0,0))
        p.addLineToPoint(CGPointMake(sz.width,0))
        p.addLineToPoint(CGPointMake(sz.width,sz.height))
        p.addLineToPoint(CGPointMake(sz.width/4.0,sz.height))
        p.addLineToPoint(CGPointMake(sz.width,sz.height/2.0))
        p.closePath()
        self.tv.textContainer.exclusionPaths = [p]
    }
}
