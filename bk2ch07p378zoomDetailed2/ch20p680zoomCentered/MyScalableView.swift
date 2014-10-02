

import UIKit

class MyScalableView : UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.blackColor()
    }
    
    override func drawRect(rect: CGRect) {
        println("rect: \(rect); bounds: \(self.bounds); scale: \(self.layer.contentsScale)")
        
        let path = NSBundle.mainBundle().pathForResource("earthFromSaturn", ofType:"png")!
        let im = UIImage(contentsOfFile:path)!
        im.drawInRect(rect)
    }
    
    
}
