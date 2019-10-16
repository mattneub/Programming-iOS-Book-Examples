

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
        
        print(self.tv.textContainerInset)
        print(UITextView(frame:CGRect(0,0,100,100)).textContainerInset)
        
        let s = "Onions\t$2.34\nPeppers\t$15.2\n"
        let mas = NSMutableAttributedString(string:s, attributes:[
            .font:UIFont(name:"GillSans", size:15)!,
            .paragraphStyle:lend {
                (p:NSMutableParagraphStyle) in
                let terms = NSTextTab.columnTerminators(for:Locale.current)
                let tab = NSTextTab(textAlignment:.right, location:170, options:[.columnTerminators:terms])
                var which : Int { return 1 }
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
            .link : URL(string: "https://www.apple.com")!,
            .foregroundColor : UIColor.green,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]))
        // aha! son of a gun, I finally figured this out!
        // you have to set the overall `linkTextAttributes` to an empty dictionary
        
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "(805)-123-4567", attributes: nil))
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "123 Main Street, Anytown, CA 91234", attributes: nil))
        mas.append(NSAttributedString(string: "\n\n", attributes:nil))
        mas.append(NSAttributedString(string: "tomorrow at 4 PM", attributes: nil))

        
        self.tv.attributedText = mas
        
        // this works but it applies to all links
        print(self.tv.linkTextAttributes)
        self.tv.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.orange]
        self.tv.linkTextAttributes = [:]
        
//        print(NSTextAttachment.character)
//        print(0xFFFC)
        
        self.tv.isSelectable = true
        self.tv.isEditable = false
        self.tv.delegate = self
        
        do {
            let mas = NSMutableAttributedString()
            mas.append(NSAttributedString(string: "LINKNOT", attributes: [
                .link : URL(string: "https://www.apple.com")!,
                .foregroundColor : UIColor.green,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            let lab = UILabel()
            lab.attributedText = mas
            lab.sizeToFit()
            lab.isUserInteractionEnabled = true
            self.view.addSubview(lab)
            lab.frame.origin.y += 30
            // just proving that (a) you can set this appearance, and (b) you can't tap it
        }
    }
    
    func thumbnailOfImage(name:String, extension ext: String) -> UIImage {
        let url = Bundle.main.url(forResource:name,
                withExtension:ext)!
        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let scale = UIScreen.main.scale
        let w : CGFloat = 20 * scale
        let d : [CFString:Any] = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: w
        ]
        let imref =
        CGImageSourceCreateThumbnailAtIndex(src, 0, d as NSDictionary)!
        let im = UIImage(cgImage:imref, scale:scale, orientation:.up)
        return im
    }
    
}

extension UITextItemInteraction : CustomStringConvertible {
    public var description: String {
        switch self {
        case .invokeDefaultAction: return "invokeDefaultAction"
        case .presentActions: return "presentActions"
        case .preview: return "preview"
        }
    }
    
    
}

extension ViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction:UITextItemInteraction) -> Bool {
        print("attachment", interaction)
        if interaction == .preview {return false}
        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith url: Foundation.URL, in characterRange: NSRange, interaction:UITextItemInteraction) -> Bool {
        print("URL", url)
        print((textView.text as NSString).substring(with:characterRange))
        print(interaction)
        return true
    }
}
