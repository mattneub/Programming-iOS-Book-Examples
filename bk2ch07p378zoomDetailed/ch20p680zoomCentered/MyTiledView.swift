
import UIKit
import QuartzCore

class MyTiledView : UIView {
    
    var currentImage : UIImage!
    var currentSize = CGSizeZero
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
        let lay = self.layer as CATiledLayer
        let scale = lay.contentsScale
        lay.tileSize = CGSizeMake(208*scale,238*scale)
        lay.levelsOfDetail = 3
        lay.levelsOfDetailBias = 2
    }
    
    override class func layerClass() -> AnyClass {
        return CATiledLayer.self
    }
    
    override func drawRect(rect: CGRect) {
        //    NSLog(@"rect %@", NSStringFromCGRect(rect));
        //    NSLog(@"bounds %@", NSStringFromCGRect(self.bounds));
        //    NSLog(@"contents scale %f", self.layer.contentsScale);
        //    NSLog(@"%@", NSStringFromCGAffineTransform(CGContextGetCTM(UIGraphicsGetCurrentContext())));
        //    NSLog(@"%@", NSStringFromCGRect(CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext())));
        
        
        let oldSize = self.currentSize
        if !CGSizeEqualToSize(oldSize, rect.size) {
            // make a new size
            self.currentSize = rect.size
            // make a new image
            let lay = self.layer as CATiledLayer
            
            let tr = CGContextGetCTM(UIGraphicsGetCurrentContext())
            let sc = tr.a/lay.contentsScale
            let scale = sc/4.0
            
            let path = NSBundle.mainBundle().pathForResource("earthFromSaturn", ofType:"png")
            let im = UIImage(contentsOfFile:path)
            let sz = CGSizeMake(im.size.width * scale, im.size.height * scale)
            UIGraphicsBeginImageContextWithOptions(sz, true, 1)
            im.drawInRect(CGRectMake(0,0,sz.width,sz.height))
            self.currentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            NSLog("created image at size %@", NSStringFromCGSize(sz))
        }
        self.currentImage.drawInRect(self.bounds)
        
        // comment out the following! it's here just so we can see the tile boundaries
        
        let bp = UIBezierPath(rect: rect)
        UIColor.whiteColor().setStroke()
        bp.stroke()
    }
}


