

import UIKit

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController : UIViewController {
    
    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet weak var iv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // idea is to provide a test bed for playing with these parameters
        // you can see how both string-based and attributed-string-based label behaves
        
        // also now added drawing attributed string in image to show wrapping differences

        let f = UIFont(name:"GillSans", size:20)!
        
        let align : NSTextAlignment = .left
        let brk : NSLineBreakMode = .byTruncatingMiddle
        let numLines = 2
        let tighten = true
        
        let adjusts = false
        let min : CGFloat = 0.8
        let base : UIBaselineAdjustment = .none
        
        self.lab1.adjustsFontSizeToFitWidth = adjusts
        self.lab2.adjustsFontSizeToFitWidth = adjusts
        self.lab1.minimumScaleFactor = min
        self.lab2.minimumScaleFactor = min
        self.lab1.baselineAdjustment = base
        self.lab2.baselineAdjustment = base
        self.lab1.numberOfLines = numLines
        self.lab2.numberOfLines = numLines
        self.lab1.allowsDefaultTighteningForTruncation = tighten
        self.lab2.allowsDefaultTighteningForTruncation = tighten
        
        let s = "Little poltergeists make up the principal form of material manifestation."
        self.lab1.text = s
        self.lab1.font = f
        self.lab1.textAlignment = align
        self.lab1.lineBreakMode = brk
        
        
        let mas = NSMutableAttributedString(string:s, attributes:[
            .font:f,
            .paragraphStyle: lend {
                (para : NSMutableParagraphStyle) in
                para.alignment = align
                para.lineBreakMode = brk
                para.allowsDefaultTighteningForTruncation = tighten
            }
        ])
        mas.addAttribute(.foregroundColor,
            value:UIColor.blue,
            range:(mas.string as NSString).range(of:"poltergeists"))
        self.lab2.attributedText = mas

        let r = self.iv.bounds
        self.iv.image = UIGraphicsImageRenderer(size:r.size).image {
            _ in mas.draw(in:r)
        }

//        self.iv.image = imageOfSize(r.size) {
//            mas.draw(in:r)
//        }
        
        
    }
    
    
}
