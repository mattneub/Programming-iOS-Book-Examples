
import UIKit

class MyWindow: UIWindow {

   // for end of chapter 5 example
    // NB tested in split screen mode! still works
    
    override func hitTest(point: CGPoint, withEvent e: UIEvent?) -> UIView? {
        let lay = self.layer.hitTest(point)
        // ... possibly do something with that information
        // print(lay)
        print(lay?.backgroundColor)
        // print(self)
        return super.hitTest(point, withEvent:e)
    }
    
    
}
