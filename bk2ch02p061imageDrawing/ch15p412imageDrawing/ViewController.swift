

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
            
//            UIGraphicsBeginImageContextWithOptions(
//                CGSize(sz.width*2, sz.height), false, 0)
//            mars.draw(at:CGPoint(0,0))
//            mars.draw(at:CGPoint(sz.width,0))
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width*2, sz.height), format:mars.imageRendererFormat)
            self.iv1.image = r.image { _ in
                mars.draw(at:CGPoint(0,0))
                mars.draw(at:CGPoint(sz.width,0))
            }
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            
//            UIGraphicsBeginImageContextWithOptions(
//                CGSize(sz.width*2, sz.height*2), false, 0)
//            mars.draw(in:CGRect(0,0,sz.width*2,sz.height*2))
//            mars.draw(in:CGRect(sz.width/2.0, sz.height/2.0, sz.width, sz.height), blendMode: .multiply, alpha: 1.0)
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width*2, sz.height*2), format:mars.imageRendererFormat)
            self.iv2.image = r.image { _ in
                mars.draw(in:CGRect(0,0,sz.width*2,sz.height*2))
                mars.draw(in:CGRect(sz.width/2.0, sz.height/2.0, sz.width, sz.height), blendMode: .multiply, alpha: 1.0)
            }
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            
//            UIGraphicsBeginImageContextWithOptions(
//                CGSize(sz.width/2.0, sz.height), false, 0)
//            mars.draw(at:CGPoint(-sz.width/2.0,0))
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width/2.0, sz.height), format:mars.imageRendererFormat)
            self.iv3.image = r.image { _ in
                mars.draw(at:CGPoint(-sz.width/2.0,0))
            }
            // return;
            do {
                let r = UIGraphicsImageRenderer(bounds:CGRect(sz.width/2.0,0,sz.width/2.0,sz.height), format:mars.imageRendererFormat)
                self.iv3.image = r.image { _ in
                    mars.draw(at:.zero)
                }
            }
            
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            // extract each half as CGImage
            let marsCG = mars.cgImage!
            let sz = mars.size
            let marsLeft = marsCG.cropping(to:
                CGRect(0,0,sz.width/2.0,sz.height))!
            let marsRight = marsCG.cropping(to: CGRect(sz.width/2.0,0,sz.width/2.0,sz.height))!
            
//            // draw each CGImage
//            UIGraphicsBeginImageContextWithOptions(
//                CGSize(sz.width*1.5, sz.height), false, 0)
//            let con = UIGraphicsGetCurrentContext()!
//            con.draw(in:CGRect(0,0,sz.width/2.0,sz.height), image: marsLeft)
//            con.draw(in:
//                CGRect(sz.width,0,sz.width/2.0,sz.height), image:marsRight)
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            // no memory management
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height), format:mars.imageRendererFormat)
            self.iv4.image = r.image { ctx in
                let con = ctx.cgContext
                con.draw(marsLeft, in:CGRect(0,0,sz.width/2.0,sz.height))
                con.draw(marsRight, in:
                    CGRect(sz.width,0,sz.width/2.0,sz.height))
            }
            // flipped!
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            // extract each half as CGImage
            let sz = mars.size
            let marsCG = mars.cgImage!
            let marsLeft = marsCG.cropping(to:CGRect(0,0,sz.width/2.0,sz.height))
            let marsRight = marsCG.cropping(to: CGRect(sz.width/2.0,0,sz.width/2.0,sz.height))
            // draw each CGImage flipped
            
            
//            UIGraphicsBeginImageContextWithOptions(
//                CGSize(sz.width*1.5, sz.height), false, 0)
//            let con = UIGraphicsGetCurrentContext()!
//            con.draw(in:
//                CGRect(0,0,sz.width/2.0,sz.height), image:flip(marsLeft!))
//            con.draw(in:
//                CGRect(sz.width,0,sz.width/2.0,sz.height), image:flip(marsRight!))
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            // no memory management
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height), format:mars.imageRendererFormat)
            self.iv5.image = r.image {
                ctx in
                let con = ctx.cgContext
                con.draw(flip(marsLeft!), in:
                    CGRect(0,0,sz.width/2.0,sz.height))
                con.draw(flip(marsRight!), in:
                    CGRect(sz.width,0,sz.width/2.0,sz.height))
            }
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            let marsCG = mars.cgImage!
            let szCG = CGSize(CGFloat(marsCG.width), CGFloat(marsCG.height))
            let marsLeft =
                marsCG.cropping(to:CGRect(0,0,szCG.width/2.0,szCG.height))
            let marsRight =
                marsCG.cropping(to:CGRect(szCG.width/2.0,0,szCG.width/2.0,szCG.height))
            UIGraphicsBeginImageContextWithOptions(
                CGSize(sz.width*1.5, sz.height), false, 0)
            // the rest as before, draw each CGImage flipped
            
            
//            let con = UIGraphicsGetCurrentContext()!
//            con.draw(in:
//                CGRect(0,0,sz.width/2.0,sz.height), image:flip(marsLeft!))
//            con.draw(in:
//                CGRect(sz.width,0,sz.width/2.0,sz.height), image:flip(marsRight!))
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            // no memory management
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height), format:mars.imageRendererFormat)

            self.iv6.image = r.image {
                ctx in
                let con = ctx.cgContext
                con.draw(flip(marsLeft!), in:
                    CGRect(0,0,sz.width/2.0,sz.height))
                con.draw(flip(marsRight!), in:
                    CGRect(sz.width,0,sz.width/2.0,sz.height))
            }
        }
        
        // ======
        
        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            let marsCG = mars.cgImage!
            let szCG = CGSize(CGFloat(marsCG.width), CGFloat(marsCG.height))
            let marsLeft =
                marsCG.cropping(to:CGRect(0,0,szCG.width/2.0,szCG.height))
            let marsRight =
                marsCG.cropping(to:CGRect(szCG.width/2.0,0,szCG.width/2.0,szCG.height))
            
//            UIGraphicsBeginImageContextWithOptions(
//                CGSize(sz.width*1.5, sz.height), false, 0)
//            // instead of calling flip, pass through UIImage
//            UIImage(cgImage: marsLeft!, scale: mars.scale,
//                orientation: mars.imageOrientation)
//                .draw(at:CGPoint(0,0))
//            UIImage(cgImage: marsRight!, scale: mars.scale,
//                orientation: mars.imageOrientation)
//                .draw(at:CGPoint(sz.width,0))
//            let im = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            // no memory management
            
            let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height), format:mars.imageRendererFormat)

            self.iv7.image = r.image {
                _ in
                UIImage(cgImage: marsLeft!, scale: mars.scale,
                        orientation: mars.imageOrientation)
                    .draw(at:CGPoint(0,0))
                UIImage(cgImage: marsRight!, scale: mars.scale,
                        orientation: mars.imageOrientation)
                    .draw(at:CGPoint(sz.width,0))
            }
        }
        
    }
    
}

func flip (_ im: CGImage) -> CGImage {
    let sz = CGSize(CGFloat(im.width), CGFloat(im.height))
    
//    UIGraphicsBeginImageContextWithOptions(sz, false, 0)
//    UIGraphicsGetCurrentContext()!.draw(in:
//        CGRect(0, 0, sz.width, sz.height), image:im)
//    let result = UIGraphicsGetImageFromCurrentImageContext()!.cgImage
//    UIGraphicsEndImageContext()
    
    let r = UIGraphicsImageRenderer(size:sz)
    return r.image { ctx in
        ctx.cgContext.draw(im, in:
            CGRect(0, 0, sz.width, sz.height))
    }.cgImage!
}
