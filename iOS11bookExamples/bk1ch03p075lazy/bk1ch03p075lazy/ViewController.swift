

import UIKit

// singleton

class MyClass {
    static let sharedMyClassSingleton = MyClass()
}

class MyView : UIView {
    // lazy var arrow : UIImage = self.arrowImage()
    // explicit type not required if not using define-and-call
    lazy var arrow = self.arrowImage() // self not required here
    func arrowImage () -> UIImage {
        // ... big image-generating code goes here ...
        return UIImage() // stub
    }
}


class ViewController: UIViewController {
    
    lazy var prog : UIProgressView = {
        let p = UIProgressView(progressViewStyle: .default)
        p.alpha = 0.7
        p.trackTintColor = UIColor.clear
        p.progressTintColor = UIColor.black
        p.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:20)
        p.progress = 1.0
        return p
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout = UICollectionViewLayout()
        class MyDynamicAnimator : UIDynamicAnimator {}
        let anim2 = MyDynamicAnimator(collectionViewLayout:layout)
        _ = anim2
        
        

    }
    

    
    
}

