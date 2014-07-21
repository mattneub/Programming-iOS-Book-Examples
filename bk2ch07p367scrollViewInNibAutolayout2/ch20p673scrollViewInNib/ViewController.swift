
import UIKit

class ViewController : UIViewController {
    
    // same iOS 8 bug a different way
    
    // the content view in the nib is sized by it own width and height constraints,
    // and iOS 8 doesn't respect that in determining its scroll view content size
    
    // thus: scrollable in iOS 7, not in iOS 8

    
}
