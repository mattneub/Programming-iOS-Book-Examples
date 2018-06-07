
import UIKit

func lend<T> (closure:(T)->()) -> T where T:NSObject {
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
    lazy var content = self.makeAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // draw into 280 x 250 image
        let rect = CGRect(0,0,280,250)
        
        let r = UIGraphicsImageRenderer(size:rect.size)
        let im = r.image {
            ctx in let con = ctx.cgContext
            UIColor.white.setFill()
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
    
    func makeAttributedString() -> NSAttributedString {
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!
        
		let s1 = """
			The Gettysburg Address, as delivered on a certain occasion \
			(namely Thursday, November 19, 1863) by A. Lincoln
			"""
        content = NSMutableAttributedString(string:s1, attributes:[
            .font: UIFont(name:"Arial-BoldMT", size:15)!,
            .foregroundColor: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)]
        )
        let r = (content.string as NSString).range(of:"Gettysburg Address")
        let atts : [NSAttributedString.Key:Any] = [
            .strokeColor: UIColor.red,
            .strokeWidth: -2.0
        ]
        content.addAttributes(atts, range: r)
        
        content.addAttribute(.paragraphStyle,
            value:lend() {
                (para : NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .byWordWrapping
                para.alignment = .center
                para.paragraphSpacing = 15
        }, range:NSMakeRange(0,1))
        
		let s2 = """
			Fourscore and seven years ago, our fathers brought forth \
			upon this continent a new nation, conceived in liberty and \
			dedicated to the proposition that all men are created equal.
			"""
        content2 = NSMutableAttributedString(string:s2, attributes: [
            .font: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            .font: UIFont(name:"HoeflerText-Black", size:24)!,
            .expansion: 0.3,
            .kern: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))
        
        content2.addAttribute(.paragraphStyle,
            value:lend() {
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
