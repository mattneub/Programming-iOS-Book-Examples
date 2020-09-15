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



class ViewController : UIViewController {
    @IBOutlet var views: [UIView]!
    var smilers = [Smiler(), Smiler2()] // to serve as delegates
    
    @discardableResult
    func makeLayerOfClass(_ klass:CALayer.Type, andAddToView ix:Int) -> CALayer {
        let lay = klass.init()
        lay.contentsScale = UIScreen.main.scale
//        lay.contentsGravity = .bottom
//        lay.contentsRect = CGRect(0.2,0.2,0.5,0.5)
//        lay.contentsCenter = CGRect(0.0, 0.4, 1.0, 0.6)
        let v = self.views[ix]
        lay.frame = v.layer.bounds
        v.layer.addSublayer(lay)
        lay.setNeedsDisplay()
        
        // add another layer to say which view this is
        
        let tlay = CATextLayer()
        tlay.frame = lay.bounds
        lay.addSublayer(tlay)
        tlay.string = "\(ix)"
        tlay.fontSize = 30
        tlay.alignmentMode = .center
        tlay.foregroundColor = UIColor.green.cgColor
        
        return lay
    }
    
    // Big change in iOS 10: CALayerDelegate is a real protocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // four ways of getting content into a layer
        
        // 0: delegate draws
        let lay1 = self.makeLayerOfClass(CALayer.self, andAddToView:0)
        lay1.isOpaque = true // black background, kaboom
        lay1.delegate = self.smilers[0] as? CALayerDelegate
        // 1: delegate sets contents
        let lay2 = self.makeLayerOfClass(CALayer.self, andAddToView:1)
        // red background of view shows thru from behind
        lay2.delegate = self.smilers[1] as? CALayerDelegate
        // 2: subclass draws
        self.makeLayerOfClass(SmilerLayer.self, andAddToView:2)
        // 3: subclass sets contents
        self.makeLayerOfClass(SmilerLayer2.self, andAddToView:3)

    }

}

