

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
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width*2, sz.height), false, 0)
            mars.drawAtPoint(CGPointMake(0,0))
            mars.drawAtPoint(CGPointMake(sz.width,0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv1.image = im
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width*2, sz.height*2), false, 0)
            mars.drawInRect(CGRectMake(0,0,sz.width*2, sz.height*2))
            mars.drawInRect(CGRectMake(sz.width/2.0, sz.height/2.0, sz.width, sz.height), blendMode: .Multiply, alpha: 1.0)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv2.image = im
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width/2.0, sz.height), false, 0)
            mars.drawAtPoint(CGPointMake(-sz.width/2.0,0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv3.image = im
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            // extract each half as CGImage
            let marsCG = mars.CGImage
            let sz = mars.size
            let marsLeft = CGImageCreateWithImageInRect(
                marsCG,
                CGRectMake(0,0,sz.width/2.0,sz.height))
            let marsRight = CGImageCreateWithImageInRect(
                marsCG,
                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height))
            // draw each CGImage
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width*1.5, sz.height), false, 0)
            let con = UIGraphicsGetCurrentContext()!
            CGContextDrawImage(con,
                CGRectMake(0,0,sz.width/2.0,sz.height), marsLeft)
            CGContextDrawImage(con,
                CGRectMake(sz.width,0,sz.width/2.0,sz.height), marsRight)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv4.image = im
            // flipped!
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            // extract each half as CGImage
            let sz = mars.size
            let marsCG = mars.CGImage
            let marsLeft = CGImageCreateWithImageInRect(
                marsCG,
                CGRectMake(0,0,sz.width/2.0,sz.height))
            let marsRight = CGImageCreateWithImageInRect(
                marsCG,
                CGRectMake(sz.width/2.0,0,sz.width/2.0,sz.height))
            // draw each CGImage flipped
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width*1.5, sz.height), false, 0)
            let con = UIGraphicsGetCurrentContext()!
            CGContextDrawImage(con,
                CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft!))
            CGContextDrawImage(con,
                CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight!))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv5.image = im
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            let marsCG = mars.CGImage
            let szCG = CGSizeMake(CGFloat(CGImageGetWidth(marsCG)), CGFloat(CGImageGetHeight(marsCG)))
            let marsLeft =
                CGImageCreateWithImageInRect(
                    marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height))
            let marsRight =
                CGImageCreateWithImageInRect(
                    marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height))
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width*1.5, sz.height), false, 0)
            // the rest as before, draw each CGImage flipped
            let con = UIGraphicsGetCurrentContext()!
            CGContextDrawImage(con,
                CGRectMake(0,0,sz.width/2.0,sz.height), flip(marsLeft!))
            CGContextDrawImage(con,
                CGRectMake(sz.width,0,sz.width/2.0,sz.height), flip(marsRight!))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv6.image = im
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            let marsCG = mars.CGImage
            let szCG = CGSizeMake(CGFloat(CGImageGetWidth(marsCG)), CGFloat(CGImageGetHeight(marsCG)))
            let marsLeft =
                CGImageCreateWithImageInRect(
                    marsCG, CGRectMake(0,0,szCG.width/2.0,szCG.height))
            let marsRight =
                CGImageCreateWithImageInRect(
                    marsCG, CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height))
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(sz.width*1.5, sz.height), false, 0)
            // instead of calling flip, pass through UIImage
            UIImage(CGImage: marsLeft!, scale: mars.scale,
                orientation: mars.imageOrientation)
                .drawAtPoint(CGPointMake(0,0))
            UIImage(CGImage: marsRight!, scale: mars.scale,
                orientation: mars.imageOrientation)
                .drawAtPoint(CGPointMake(sz.width,0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv7.image = im
        }
        
    }
    
}

func flip (im: CGImage) -> CGImage {
    let sz = CGSizeMake(CGFloat(CGImageGetWidth(im)), CGFloat(CGImageGetHeight(im)))
    UIGraphicsBeginImageContextWithOptions(sz, false, 0)
    CGContextDrawImage(UIGraphicsGetCurrentContext()!,
        CGRectMake(0, 0, sz.width, sz.height), im)
    let result = UIGraphicsGetImageFromCurrentImageContext().CGImage
    UIGraphicsEndImageContext()
    return result!
}
