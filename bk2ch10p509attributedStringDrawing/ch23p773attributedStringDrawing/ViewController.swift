
import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

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



class ViewController : UIViewController {
    @IBOutlet var drawer : StringDrawer!
    @IBOutlet var iv : UIImageView!
    lazy var content : AttributedString = self.makeAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // draw into 280 x 250 image
        let rect = CGRect(0,0,280,250)
        let r = UIGraphicsImageRenderer(size:rect.size)
        let im = r.image {
            ctx in let con = ctx.cgContext
            UIColor.white().setFill()
            con.fill(rect)
            content.draw(in:rect) // draw attributed string
        }

        
//        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
//        UIColor.white().setFill()
//        UIGraphicsGetCurrentContext()!.fill(rect)
//        content.draw(in:rect) // draw attributed string
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        // display the image
        
        self.iv.image = im
        
        // another way: draw the string in a view's drawRect:
        
        self.drawer.attributedText = content
        
    }
    
    func makeAttributedString() -> AttributedString {
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!
        
        let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
        "(namely Thursday, November 19, 1863) by A. Lincoln"
        content = NSMutableAttributedString(string:s1, attributes:[
            NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:15)!,
            NSForegroundColorAttributeName: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)]
        )

        let r = (s1 as NSString).range(of:"Gettysburg Address")
        content.addAttributes([
            NSStrokeColorAttributeName: UIColor.red(),
            NSStrokeWidthAttributeName: -2.0
        ], range: r)
        
        content.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
            (para:NSMutableParagraphStyle) in
            para.headIndent = 10
            para.firstLineHeadIndent = 10
            para.tailIndent = -10
            para.lineBreakMode = .byWordWrapping
            para.alignment = .center
            para.paragraphSpacing = 15
        }, range:NSMakeRange(0,1))
        
        var s2 = "Fourscore and seven years ago, our fathers brought forth " +
            "upon this continent a new nation, conceived in liberty and dedicated "
        s2 = s2 + "to the proposition that all men are created equal."
        content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))
        
        content2.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
            (para2 : NSMutableParagraphStyle) in
            para2.headIndent = 10
            para2.firstLineHeadIndent = 10
            para2.tailIndent = -10
            para2.lineBreakMode = .byWordWrapping
            para2.alignment = .justified
            para2.lineHeightMultiple = 1.2
            para2.hyphenationFactor = 1.0
        }, range:NSMakeRange(0,1))
        
        let end = content.length
        content.replaceCharacters(in:NSMakeRange(end, 0), with:"\n")
        content.append(content2)
        
        return content
        
    }
    
    
}
