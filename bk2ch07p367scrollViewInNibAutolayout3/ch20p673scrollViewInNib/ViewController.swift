
import UIKit

class ViewController : UIViewController {
    
}

// workaround for the iOS 8 scrolling bug
// one of the four views has an _intrinsic_ size
// and the other three are sized in terms of this one
// so this scroll view is scrollable in iOS 8

class MyView : UIView {
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(200,173)
    }
}
