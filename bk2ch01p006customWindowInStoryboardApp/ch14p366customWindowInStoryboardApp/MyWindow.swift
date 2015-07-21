
import UIKit

class MyWindow: UIWindow {

   // for end of chapter 5 example
    
    override func hitTest(point: CGPoint, withEvent e: UIEvent?) -> UIView? {
        let lay = self.layer.hitTest(point)
        // ... possibly do something with that information
        print(lay)
        print(self)
        return super.hitTest(point, withEvent:e)
    }
    
    
}
