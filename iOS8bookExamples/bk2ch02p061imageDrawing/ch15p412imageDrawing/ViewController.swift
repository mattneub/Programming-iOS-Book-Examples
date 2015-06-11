

import UIKit

class ViewController : UIViewController {
    @IBOutlet var iv1 : UIImageView!
    @IBOutlet var iv2 : UIImageView!
    @IBOutlet var iv3 : UIImageView!
    @IBOutlet var iv4 : UIImageView!
    @IBOutlet var iv5 : UIImageView!
    @IBOutlet var iv6 : UIImageView!
    @IBOutlet var iv7 : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ======
        
        var mars = UIImage(named:"Mars")!
        var sz = mars.size
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width*2, sz.height), false, 0)
        mars.drawAtPoint(CGPointMake(0,0))
        mars.drawAtPoint(CGPointMake(sz.width,0))
        var im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.iv1.image = im
        
        // ======
        
        mars = UIImage(named:"Mars")!
        sz = mars.size
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width*2, sz.height*2), false, 0)
        mars.drawInRect(CGRectMake(0,0,sz.width*2, sz.height*2))
        mars.drawInRect(CGRectMake(sz.width/2.0, sz.height/2.0, sz.width, sz.height), blendMode: kCGBlendModeMultiply, alpha: 1.0)
        im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.iv2.image = im
        
        // ======
        
        mars = UIImage(named:"Mars")!
        sz = mars.size
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width/2.0, sz.height), false, 0)
        mars.drawAtPoint(CGPointMake(-sz.width/2.0,0))
        im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.iv3.image = im
        
        // ======
        
        mars = UIImage(named:"Mars")!
        // extract each half as CGImage
        sz = mars.size
        var marsLeft = CGImageCreateWithImageInRect(
            mars.CGImage,
            CGRectMake(0,0,sz.width/2.0,sz.height))
        var marsRight = CGImageCreateWithImageInRect(
            mars.CGImage,
            CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height))
        // draw each CGImage
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width*1.5, sz.height), false, 0)
        var con = UIGraphicsGetCurrentContext()
        CGContextDrawImage(con,
            CGRectMake(0,0,sz.width/2.0,sz.height), marsLeft)
        CGContextDrawImage(con,
            CGRectMake(sz.width,0,sz.width/2.0,sz.height), marsRight)
        im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // no memory management
        self.iv4.image = im
        // flipped!
        
        // ======
        
        mars = UIImage(named:"Mars")!
        // extract each half as CGImage
        sz = mars.size
        marsLeft = CGImageCreateWithImageInRect(
            mars.CGImage,
            CGRectMake(0,0,sz.width/2.0,sz.height))
        marsRight = CGImageCreateWithImageInRect(
            mars.CGImage,
            CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height))
        // draw each CGImage flipped
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width*1.5, sz.height), false, 0)
        con = UIGraphicsGetCurrentContext()
        CGContextDrawImage(con,
            CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft))
        CGContextDrawImage(con,
            CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight))
        im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // no memory management
        self.iv5.image = im
        
        // ======
        
        mars = UIImage(named:"Mars")!
        sz = mars.size
        // derive CGImage first, use its dimensions to extract its halves
        var marsCG = mars.CGImage
        var szCG = CGSizeMake(CGFloat(CGImageGetWidth(marsCG)), CGFloat(CGImageGetHeight(marsCG)))
        marsLeft =
            CGImageCreateWithImageInRect(
                marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height))
        marsRight =
            CGImageCreateWithImageInRect(
                marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height))
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width*1.5, sz.height), false, 0)
        // the rest as before, draw each CGImage flipped
        con = UIGraphicsGetCurrentContext()
        CGContextDrawImage(con,
            CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft))
        CGContextDrawImage(con,
            CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight))
        im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // no memory management
        self.iv6.image = im
        
        // ======
        
        mars = UIImage(named:"Mars")!
        sz = mars.size
        // derive CGImage first, use its dimensions to extract its halves
        marsCG = mars.CGImage
        szCG = CGSizeMake(CGFloat(CGImageGetWidth(marsCG)), CGFloat(CGImageGetHeight(marsCG)))
        marsLeft =
            CGImageCreateWithImageInRect(
                marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height))
        marsRight =
            CGImageCreateWithImageInRect(
                marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height))
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.width*1.5, sz.height), false, 0)
        // instead of calling flip, pass through UIImage
        UIImage(CGImage: marsLeft, scale: mars.scale,
            orientation: mars.imageOrientation)!
            .drawAtPoint(CGPointMake(0,0))
        UIImage(CGImage: marsRight, scale: mars.scale,
            orientation: mars.imageOrientation)!
            .drawAtPoint(CGPointMake(sz.width,0))
        im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // no memory management
        self.iv7.image = im
        
        
    }
    
}

func flip (im: CGImage) -> CGImage {
    let sz = CGSizeMake(CGFloat(CGImageGetWidth(im)), CGFloat(CGImageGetHeight(im)))
    UIGraphicsBeginImageContextWithOptions(sz, false, 0)
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
        CGRectMake(0, 0, sz.width, sz.height), im)
    let result = UIGraphicsGetImageFromCurrentImageContext().CGImage
    UIGraphicsEndImageContext()
    return result;
}
