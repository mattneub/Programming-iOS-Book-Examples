
import UIKit


let TILESIZE : CGFloat = 256

class ViewController : UIViewController {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var content : TiledView!
    
    override func viewDidLoad() {
        let f = CGRectMake(0,0,3*TILESIZE,3*TILESIZE)
        let content = TiledView(frame:f)
        let tsz = TILESIZE * content.layer.contentsScale
        (content.layer as! CATiledLayer).tileSize = CGSizeMake(tsz, tsz)
        self.sv.addSubview(content)
        self.sv.contentSize = f.size
        self.content = content
    }
}

// there were low-memory problems with CATiledLayer in early versions of iOS 7
// but they seem to be gone now

class TiledView : UIView {
    
    let drawQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)

    
    override class func layerClass() -> AnyClass {
        return CATiledLayer.self
    }
    
    // not sure what this was supposed to do
    /*
    - (void)setContentScaleFactor:(CGFloat)contentScaleFactor
    {
    [super setContentScaleFactor:1.f];
    }
    */
    
    override func drawRect(r: CGRect) {
        dispatch_sync(drawQueue, { // work around nasty thread issue...
            // we are called twice simultaneously on two different background threads!
            
            NSLog("%@", "drawRect: \(r)")
            
            let tile = r
            let x = Int(tile.origin.x/TILESIZE)
            let y = Int(tile.origin.y/TILESIZE)
            let tileName = String(format:"CuriousFrog_500_\(x+3)_\(y)")
            let path = NSBundle.mainBundle().pathForResource(tileName, ofType:"png")!
            let image = UIImage(contentsOfFile:path)!
            
            image.drawAtPoint(CGPointMake(CGFloat(x)*TILESIZE,CGFloat(y)*TILESIZE))
            
            // in real life, comment out the following! it's here just so we can see the tile boundaries
            
            let bp = UIBezierPath(rect: r)
            UIColor.whiteColor().setStroke()
            bp.stroke()
        })
    }
}

