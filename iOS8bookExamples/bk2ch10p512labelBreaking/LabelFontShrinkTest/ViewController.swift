

import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}


class ViewController : UIViewController {
    
    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet weak var iv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // idea is to provide a test bed for playing with these parameters
        // you can see how both string-based and attributed-string-based label behaves
        // (and if there differences between iOS 7 and iOS 8)
        
        // also now added drawing attributed string in image to show wrapping differences
        

        let f = UIFont(name:"GillSans", size:20)!
        
        let align : NSTextAlignment = .Left
        let brk : NSLineBreakMode = .ByTruncatingTail
        let numLines = 2
        
        let adjusts = false
        let min : CGFloat = 0.8
        let base : UIBaselineAdjustment = .None
        
        self.lab1.adjustsFontSizeToFitWidth = adjusts
        self.lab2.adjustsFontSizeToFitWidth = adjusts
        self.lab1.minimumScaleFactor = min
        self.lab2.minimumScaleFactor = min
        self.lab1.baselineAdjustment = base
        self.lab2.baselineAdjustment = base
        self.lab1.numberOfLines = numLines
        self.lab2.numberOfLines = numLines
        
        let s = "Little poltergeists make up the principal form of spontaneous material manifestation."
        self.lab1.text = s
        self.lab1.font = f
        self.lab1.textAlignment = align
        self.lab1.lineBreakMode = brk
        
        
        let mas = NSMutableAttributedString(string:s, attributes:[
            NSFontAttributeName:f,
            NSParagraphStyleAttributeName: lend {
                (para : NSMutableParagraphStyle) in
                para.alignment = align
                para.lineBreakMode = brk
            }
        ])
        mas.addAttribute(NSForegroundColorAttributeName,
            value:UIColor.blueColor(),
            range:(s as NSString).rangeOfString("poltergeists"))
        self.lab2.attributedText = mas

        let r = self.iv.bounds
        self.iv.image = imageOfSize(r.size) {
            mas.drawInRect(r)
        }
        
        
    }
    
    
}
