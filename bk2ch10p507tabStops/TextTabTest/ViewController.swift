

import UIKit
import ImageIO

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



func lend<T> (closure:(T)->()) -> T where T:NSObject {
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
                let terms = NSTextTab.columnTerminators(for:Locale.current)
                let tab = NSTextTab(textAlignment:.right, location:170, options:[NSTabColumnTerminatorsAttributeName:terms])
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
        
        let onions = self.thumbnailOfImage(name:"onion", extension:"jpg")
        let peppers = self.thumbnailOfImage(name:"peppers", extension:"jpg")
        
        let onionatt = NSTextAttachment()
        onionatt.image = onions
        onionatt.bounds = CGRect(0,-5,onions.size.width,onions.size.height)
        let onionattchar = NSAttributedString(attachment:onionatt)
        
        let pepperatt = NSTextAttachment()
        pepperatt.image = peppers
        pepperatt.bounds = CGRect(0,-1,peppers.size.width,peppers.size.height)
        let pepperattchar = NSAttributedString(attachment:pepperatt)
        
        let r = (mas.string as NSString).range(of:"Onions")
        mas.insert(onionattchar, at:(r.location + r.length))
        let r2 = (mas.string as NSString).range(of:"Peppers")
        mas.insert(pepperattchar, at:(r2.location + r2.length))
        
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "LINK", attributes: [
            NSLinkAttributeName : URL(string: "http://www.apple.com")!
            ]))
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "(805)-123-4567", attributes: nil))
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "123 Main Street, Anytown, CA 91234", attributes: nil))
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "tomorrow at 4 PM", attributes: nil))

        
        self.tv.attributedText = mas
        
//        println(NSAttachmentCharacter)
//        println(0xFFFC)
        
        self.tv.isSelectable = true
        self.tv.isEditable = false
        self.tv.delegate = self
    }
    
    func thumbnailOfImage(name:String, extension ext: String) -> UIImage {
        let url = Bundle.main.url(forResource:name,
                withExtension:ext)!
        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let scale = UIScreen.main.scale
        let w : CGFloat = 20 * scale
        let d : NSDictionary = [
            kCGImageSourceShouldAllowFloat : true as NSNumber,
            kCGImageSourceCreateThumbnailWithTransform: true as NSNumber,
            kCGImageSourceCreateThumbnailFromImageAlways: true as NSNumber,
            kCGImageSourceThumbnailMaxPixelSize: Int(w) as NSNumber
        ]
        let imref =
        CGImageSourceCreateThumbnailAtIndex(src, 0, d)!
        let im = UIImage(cgImage:imref, scale:scale, orientation:.up)
        return im
    }
    
}

extension ViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: Foundation.URL, in characterRange: NSRange) -> Bool {
        print(URL)
        print((textView.text as NSString).substring(with:characterRange))
        return true
    }
}
