
import UIKit

class ViewController : UIViewController {
    
    // the content view in the nib is sized by its own width and height constraints
    
    // for this approach, we do need a content view even in iOS 11...
    // ...because we cannot set the size of the contentLayoutGuide in the nib editor
    
    // still using trick where we set insets to Always in nib, to avoid launch position bug
        
}
