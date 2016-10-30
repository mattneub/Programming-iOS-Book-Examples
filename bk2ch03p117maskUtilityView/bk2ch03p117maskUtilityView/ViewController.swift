

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

    
//    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
//    let con = UIGraphicsGetCurrentContext()!
//    con.setFillColor(UIColor(white:0, alpha:0).cgColor)
//    con.fill(rect)
//    con.setFillColor(UIColor(white:0, alpha:1).cgColor)
//    let p = UIBezierPath(roundedRect:rect, cornerRadius:rad)
//    p.fill()
//    let im = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
    
    let mask = CALayer()
    mask.frame = rect
    mask.contents = im.cgImage
    return mask
}

func viewMask(size sz:CGSize, roundingCorners rad:CGFloat) -> UIView {
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
    
//    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
//    let con = UIGraphicsGetCurrentContext()!
//    con.setFillColor(UIColor(white:0, alpha:0).cgColor)
//    con.fill(rect)
//    con.setFillColor(UIColor(white:0, alpha:1).cgColor)
//    let p = UIBezierPath(roundedRect:rect, cornerRadius:rad)
//    p.fill()
//    let im = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
    
    let iv = UIImageView(frame:CGRect(origin: .zero, size: sz))
    iv.contentMode = .scaleToFill
    iv.image = im
    iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return iv
}

/*
class MaskView : UIView {
    let rad : CGFloat
    init(frame:CGRect, roundingCorners rad : CGFloat) {
        self.rad = rad
        super.init(frame:frame)
        self.layer.needsDisplayOnBoundsChange = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(r: CGRect) {
        print("drawing")
        let con = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(
            con, UIColor(white:0, alpha:0).cgColor)
        CGContextFillRect(con, r)
        CGContextSetFillColorWithColor(
            con, UIColor(white:0, alpha:1).cgColor)
        let p = UIBezierPath(roundedRect:r, cornerRadius:rad)
        p.fill()
    }
}
*/

class ViewController: UIViewController {
    @IBOutlet var iv: UIImageView!

    let which = 2

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch which {
        case 1:
            let theMask = mask(size:self.iv.bounds.size, roundingCorners:20)
            self.iv.layer.mask = theMask
        case 2:
            let theMask = viewMask(size:self.iv.bounds.size, roundingCorners:20)
            print(self.iv.layer.mask as Any)

            self.iv.mask = theMask
            // same effect, but we've added a subview that does the masking
            // but this does not help, for instance, with the rotation problem
            // (the mask is not resized on rotation;
            // in fact, as far as I can tell, autoresizing doesn't work on the mask view)
            
            print(self.iv.layer.mask as Any)
        default: break
        }
    }
    

}

