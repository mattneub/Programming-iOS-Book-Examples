

import UIKit

// singleton

class MyClass {
    static let sharedMyClassSingleton = MyClass()
}

class MyView : UIView {
    lazy var arrow : UIImage = self.arrowImage()
    func arrowImage () -> UIImage {
        // ... big image-generating code goes here ...
        return UIImage() // stub
    }
}


class ViewController: UIViewController {
    
    lazy var prog : UIProgressView = {
        let p = UIProgressView(progressViewStyle: .Default)
        p.alpha = 0.7
        p.trackTintColor = UIColor.clearColor()
        p.progressTintColor = UIColor.blackColor()
        p.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20)
        p.progress = 1.0
        return p
    }()
    
    
    // how "lazy" is implemented
    
    private var lazyOncer : dispatch_once_t = 0
    private var lazyBacker : Int = 0
    var lazyFront : Int {
        get {
            dispatch_once(&self.lazyOncer) {
                self.lazyBacker = 42 // expensive initial value
            }
            return self.lazyBacker
        }
        set {
            dispatch_once(&self.lazyOncer) {}
            // will set
            self.lazyBacker = newValue
            // did set
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout = UICollectionViewLayout()
        class MyDynamicAnimator : UIDynamicAnimator {}
        let anim2 = MyDynamicAnimator(collectionViewLayout:layout)
        _ = anim2

    }
    
    
}

