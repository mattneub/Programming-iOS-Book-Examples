

import UIKit
import ImageIO

class ViewController : UIViewController {
    @IBOutlet var tv : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = "Onions\t$2.34\nPeppers\t$15.2\n"
        let p = NSMutableParagraphStyle()
        var tabs = [NSTextTab]()
        let terms = NSTextTab.columnTerminatorsForLocale(NSLocale.currentLocale())
        let tab = NSTextTab(textAlignment:.Right, location:170, options:[NSTabColumnTerminatorsAttributeName:terms])
        tabs += tab
        p.tabStops = tabs
        p.firstLineHeadIndent = 20
        let mas = NSMutableAttributedString(string:s, attributes:[
                NSFontAttributeName:UIFont(name:"GillSans", size:15),
                NSParagraphStyleAttributeName:p
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
        
        self.tv.attributedText = mas
    }
    
    func thumbnailOfImageWithName(name:String, withExtension ext: String) -> UIImage {
        let url = NSBundle.mainBundle().URLForResource(name,
                withExtension:ext)
        let src = CGImageSourceCreateWithURL(url, nil).takeRetainedValue()
        let scale = UIScreen.mainScreen().scale
        let w : CGFloat = 20 * scale
        let d = [
            kCGImageSourceShouldAllowFloat : kCFBooleanTrue,
            kCGImageSourceCreateThumbnailWithTransform: kCFBooleanTrue,
            kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
            kCGImageSourceThumbnailMaxPixelSize: Int(w)
        ]
        let imref =
            CGImageSourceCreateThumbnailAtIndex(src, 0, d).takeRetainedValue()
        let im = UIImage(CGImage:imref, scale:scale, orientation:.Up)
        return im
    }
    
}
