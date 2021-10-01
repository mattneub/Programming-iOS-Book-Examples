import UIKit

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


class ViewController : UIViewController {
    
    func mask(size sz:CGSize, roundingCorners rad:CGFloat) -> CALayer {
        let rect = CGRect(origin:.zero, size:sz)
        let r = UIGraphicsImageRenderer(bounds:rect)
        let im = r.image {
            ctx in
            let con = ctx.cgContext
            con.setFillColor(UIColor(white:0, alpha:0).cgColor)
            con.fill(rect)
            con.setFillColor(UIColor(white:0, alpha:1).cgColor)
            let p = UIBezierPath(roundedRect:rect, cornerRadius:rad)
            p.fill()
        }

        
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
//        let con = UIGraphicsGetCurrentContext()!
//        con.setFillColor(UIColor(white:0, alpha:0).cgColor)
//        con.fill(rect)
//        con.setFillColor(UIColor(white:0, alpha:1).cgColor)
//        let p = UIBezierPath(roundedRect:rect, cornerRadius:rad)
//        p.fill()
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        let mask = CALayer()
        mask.frame = rect
        mask.contents = im.cgImage
        return mask
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lay = CALayer()
        lay.frame = self.view.layer.bounds
        self.view.layer.addSublayer(lay)

        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(113, 111, 132, 194)
        lay.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(43, 197, 160, 230)
        lay.addSublayer(lay3)

        let mask = self.mask(size: CGSize(100,100), roundingCorners: 20)
        mask.frame.origin = CGPoint(110,160)
        lay.mask = mask
        // lay.setValue(mask, forKey: "mask")
    }
    
}
