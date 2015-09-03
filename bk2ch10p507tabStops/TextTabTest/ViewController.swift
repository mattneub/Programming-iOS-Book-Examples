

import UIKit
import ImageIO

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController : UIViewController {
    @IBOutlet var tv : UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = "Onions\t$2.34\nPeppers\t$15.2\n"
        let mas = NSMutableAttributedString(string:s, attributes:[
            NSFontAttributeName:UIFont(name:"GillSans", size:15)!,
            NSParagraphStyleAttributeName:lend {
                (p:NSMutableParagraphStyle) in
                let terms = NSTextTab.columnTerminatorsForLocale(NSLocale.currentLocale())
                let tab = NSTextTab(textAlignment:.Right, location:170, options:[NSTabColumnTerminatorsAttributeName:terms])
                var which : Int { return 2 }
                switch which {
                case 1:
                    p.tabStops = [tab]
                case 2:
                    for oldTab in p.tabStops {
                        p.removeTabStop(oldTab)
                    }
                    p.addTabStop(tab)
                default: break
                }
                
                p.firstLineHeadIndent = 20
            }
            ])
        self.tv.attributedText = mas
        
        // return;
        
        let onions = self.thumbnailOfImageWithName("onion", withExtension:"jpg")
        let peppers = self.thumbnailOfImageWithName("peppers", withExtension:"jpg")
        
        let onionatt = NSTextAttachment()
        onionatt.image = onions
        onionatt.bounds = CGRectMake(0,-5,onions.size.width,onions.size.height)
        let onionattchar = NSAttributedString(attachment:onionatt)
        
        let pepperatt = NSTextAttachment()
        pepperatt.image = peppers
        pepperatt.bounds = CGRectMake(0,-1,peppers.size.width,peppers.size.height)
        let pepperattchar = NSAttributedString(attachment:pepperatt)
        
        let r = (mas.string as NSString).rangeOfString("Onions")
        mas.insertAttributedString(onionattchar, atIndex:(r.location + r.length))
        let r2 = (mas.string as NSString).rangeOfString("Peppers")
        mas.insertAttributedString(pepperattchar, atIndex:(r2.location + r2.length))
        
        mas.appendAttributedString(NSAttributedString(string: "\n\n", attributes:nil))
        mas.appendAttributedString(NSAttributedString(string: "LINK", attributes: [
            NSLinkAttributeName : NSURL(string: "http://www.apple.com")!
            ]))
        mas.appendAttributedString(NSAttributedString(string: "\n\n", attributes:nil))
        mas.appendAttributedString(NSAttributedString(string: "(805)-123-4567", attributes: nil))
        mas.appendAttributedString(NSAttributedString(string: "\n\n", attributes:nil))
        mas.appendAttributedString(NSAttributedString(string: "123 Main Street, Anytown, CA 91234", attributes: nil))
        mas.appendAttributedString(NSAttributedString(string: "\n\n", attributes:nil))
        mas.appendAttributedString(NSAttributedString(string: "tomorrow at 4 PM", attributes: nil))

        
        self.tv.attributedText = mas
        
//        println(NSAttachmentCharacter)
//        println(0xFFFC)
        
        self.tv.selectable = true
        self.tv.editable = false
        self.tv.delegate = self
    }
    
    func thumbnailOfImageWithName(name:String, withExtension ext: String) -> UIImage {
        let url = NSBundle.mainBundle().URLForResource(name,
                withExtension:ext)!
        let src = CGImageSourceCreateWithURL(url, nil)!
        let scale = UIScreen.mainScreen().scale
        let w : CGFloat = 20 * scale
        let d : [NSObject:AnyObject] = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(w)
        ]
        let imref =
        CGImageSourceCreateThumbnailAtIndex(src, 0, d)!
        let im = UIImage(CGImage:imref, scale:scale, orientation:.Up)
        return im
    }
    
}

extension ViewController : UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        print(URL)
        print((textView.text as NSString).substringWithRange(characterRange))
        return true
    }
}
