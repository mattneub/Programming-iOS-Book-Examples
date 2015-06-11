
import UIKit

class ViewController : UIViewController {
    
}

// one of the four views has an _intrinsic_ size
// and the other three are sized in terms of this one
// so this scroll view is scrollable in iOS 8

// THIS BUG WAS FIXED IN SEED 5
// so this example, while it works, is no longer needed

class MyView : UIView {
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(200,173)
    }
}
