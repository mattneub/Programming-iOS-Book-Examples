
import UIKit

class SecondViewController : UIViewController {
    
    override func supportedInterfaceOrientations() -> Int {
        print(self)
        print(" ")
        println(__FUNCTION__)
        return Int(UIInterfaceOrientationMask.Landscape.toRaw()) // called, but pointless
    }
    
}
