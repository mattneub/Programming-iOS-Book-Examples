

import UIKit

class MyScalableView : UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.black()
    }
    
    override func draw(_ rect: CGRect) {
        print("rect: \(rect); bounds: \(self.bounds); scale: \(self.layer.contentsScale)")
        
        let path = NSBundle.main().pathForResource("earthFromSaturn", ofType:"png")!
        let im = UIImage(contentsOfFile:path)!
        im.draw(in:rect)
    }
    
    
}
