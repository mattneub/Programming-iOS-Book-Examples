
import UIKit

class MyView : UIView {
    
    override init (frame:CGRect) {
        super.init(frame:frame)
        self.opaque = false
        self.backgroundColor = UIColor.redColor()
        // clearRect will cause a black square
        self.backgroundColor = self.backgroundColor!.colorWithAlphaComponent(1)
        // but uncomment the next line: clearRect will cause a clear square!
        // self.backgroundColor = self.backgroundColor!.colorWithAlphaComponent(0.99)
        
        println("Layer opaque: \(self.layer.opaque)")
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func drawRect(rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
        CGContextFillRect(con, rect)
        CGContextClearRect(con, CGRectMake(0,0,30,30))

    }
    
}