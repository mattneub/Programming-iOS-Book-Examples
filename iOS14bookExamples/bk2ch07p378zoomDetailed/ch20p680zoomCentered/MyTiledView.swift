
import UIKit

class MyTiledView : UIView {
    
    var currentImage : UIImage!
    var currentSize : CGSize = .zero
    
    let drawQueue = DispatchQueue(label: "drawQueue")
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let lay = self.layer as! CATiledLayer
        let scale = lay.contentsScale
        lay.tileSize = CGSize(208*scale,238*scale)
        lay.levelsOfDetail = 3
        lay.levelsOfDetailBias = 2
    }
    
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        print("draw")
        
//        NSLog("rect %@", NSStringFromCGRect(rect));
//        NSLog("bounds %@", NSStringFromCGRect(self.bounds));
//        NSLog("contents scale %f", self.layer.contentsScale);
//        NSLog("%@", NSStringFromCGAffineTransform(UIGraphicsGetCurrentContext()!.ctm));
//        NSLog("%@", NSStringFromCGRect(UIGraphicsGetCurrentContext()!.boundingBoxOfClipPath));
        
        // self.drawQueue.sync { // work around nasty thread issue...
        // we are called twice simultaneously on two different background threads!
        // but it looks like that issue is gone
        // we may be called back on a background thread, but not twice at once
        do {
            
            // gather needed info on main thread
            // alas, I was always doing this wrong before; now thread checker has caught me!
            let (lay, bounds) = DispatchQueue.main.sync {
                return (self.layer as! CATiledLayer, self.bounds)
            }
            let oldSize = self.currentSize
            NSLog("oldSize %@", NSCoder.string(for: oldSize))
            NSLog("rect.size %@", NSCoder.string(for: rect.size))
            if !oldSize.equalTo(rect.size) {
                print(Thread.isMainThread)
                NSLog("%@", "not equal, making new size")
                // make a new size
                self.currentSize = rect.size
                // make a new image
                
                let tr = UIGraphicsGetCurrentContext()!.ctm
                let sc = tr.a/lay.contentsScale
                let scale = sc/4.0
                
                let path = Bundle.main.path(
                    forResource: "earthFromSaturn", ofType:"png")!
                let im = UIImage(contentsOfFile:path)!
                let sz = CGSize(im.size.width * scale, im.size.height * scale)
                
                
                let f = UIGraphicsImageRendererFormat.default()
                f.opaque = true; f.scale = 1 // *
                let r = UIGraphicsImageRenderer(size: sz, format: f)
                self.currentImage = r.image { _ in
                    im.draw(in:CGRect(origin:.zero, size:sz))
                }

                
//                UIGraphicsBeginImageContextWithOptions(sz, true, 1)
//                im.draw(in:CGRect(0,0,sz.width,sz.height))
//                self.currentImage = UIGraphicsGetImageFromCurrentImageContext()!
//                UIGraphicsEndImageContext()
                
                NSLog("created image at size %@", NSCoder.string(for: sz)) // only three times
            }
            self.currentImage?.draw(in:bounds)
            
            // comment out the following! it's here just so we can see the tile boundaries
            
            let bp = UIBezierPath(rect: rect)
            UIColor.white.setStroke()
            bp.stroke()
            
        }
    }
}


