
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
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



let kTILESIZE : CGFloat = 256

class ViewController : UIViewController {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var content : TiledView!
    
    override func viewDidLoad() {
        let f = CGRect(0,0,3*kTILESIZE,3*kTILESIZE)
        let content = TiledView(frame:f)
        let tsz = kTILESIZE * content.layer.contentsScale
        (content.layer as! CATiledLayer).tileSize = CGSize(tsz, tsz)
        self.sv.addSubview(content)
        self.sv.contentSize = f.size
        self.content = content
    }
}

// there were low-memory problems with CATiledLayer in early versions of iOS 7
// but they seem to be gone now

class TiledView : UIView {
    
    let drawQueue = DispatchQueue(label: "drawQueue", attributes: DispatchQueueAttributes.serial)

    
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
    
    override func draw(_ r: CGRect) {
        drawQueue.sync { // work around nasty thread issue...
            // we are called twice simultaneously on two different background threads!
            
            NSLog("%@", "drawRect: \(r)")
            
            let tile = r
            let x = Int(tile.origin.x/kTILESIZE)
            let y = Int(tile.origin.y/kTILESIZE)
            let tileName = String(format:"CuriousFrog_500_\(x+3)_\(y)")
            let path = Bundle.main.pathForResource(tileName, ofType:"png")!
            let image = UIImage(contentsOfFile:path)!
            
            image.draw(at:CGPoint(CGFloat(x)*kTILESIZE,CGFloat(y)*kTILESIZE))
            
            // in real life, comment out the following! it's here just so we can see the tile boundaries
            
            let bp = UIBezierPath(rect: r)
            UIColor.white().setStroke()
            bp.stroke()
        }
    }
}

