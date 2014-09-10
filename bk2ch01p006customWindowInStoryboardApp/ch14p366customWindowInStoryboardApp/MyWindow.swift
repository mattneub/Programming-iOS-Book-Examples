
import UIKit

class MyWindow: UIWindow {

   // for end of chapter 5 example
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let lay = self.layer.hitTest(point)
        // ... possibly do something with that information
        println(lay)
        return super.hitTest(point, withEvent:event)
    }
    
    
}
