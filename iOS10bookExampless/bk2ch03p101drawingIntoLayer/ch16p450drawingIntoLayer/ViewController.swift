import UIKit


class ViewController : UIViewController {
    @IBOutlet var views: NSArray?
    var smilers = [Smiler(), Smiler2()] // to serve as delegates
    
    @discardableResult
    func makeLayerOfClass(_ klass:CALayer.Type, andAddToView ix:Int) -> CALayer {
        let lay = klass.init()
        lay.contentsScale = UIScreen.main.scale
        //    lay.contentsGravity = kCAGravityBottom
        //    lay.contentsRect = CGRect(0.2,0.2,0.5,0.5)
        //    lay.contentsCenter = CGRect(0.0, 0.4, 1.0, 0.6)
        let v = (self.views! as! [UIView])[ix]
        lay.frame = v.layer.bounds
        v.layer.addSublayer(lay)
        lay.setNeedsDisplay()
        
        // add another layer to say which view this is
        
        let tlay = CATextLayer()
        tlay.frame = lay.bounds
        lay.addSublayer(tlay)
        tlay.string = "\(ix)"
        tlay.fontSize = 30
        tlay.alignmentMode = kCAAlignmentCenter
        tlay.foregroundColor = UIColor.green.cgColor
        
        return lay;
    }
    
    // Big change in iOS 10: CALayerDelegate is a real protocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // four ways of getting content into a layer
        
        // 0: delegate draws
        self.makeLayerOfClass(CALayer.self, andAddToView:0).delegate = self.smilers[0] as? CALayerDelegate
        // 1: delegate sets contents
        self.makeLayerOfClass(CALayer.self, andAddToView:1).delegate = self.smilers[1] as? CALayerDelegate
        // 2: subclass draws
        self.makeLayerOfClass(SmilerLayer.self, andAddToView:2)
        // 3: subclass sets contents
        self.makeLayerOfClass(SmilerLayer2.self, andAddToView:3)

    }

}
