

import UIKit

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description: String {
        return self == .compact ? "compact" : "regular"
    }
    
    
}

class FirstViewController: UIViewController {

    // see storyboard for image configuration
    
    // run on 5s or similar to see issues with smaller image
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        // this doesn't work; in landscape, the selected image isn't used
        // I regard this as a major bug
        self.tabBarItem.selectedImage = UIImage(named: "smiley")!
        // this doesn't solve it even though "second" is a PDF
        // self.tabBarItem.selectedImage = UIImage(named: "second")!


    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("horiz", self.traitCollection.horizontalSizeClass)
        print("vert", self.traitCollection.verticalSizeClass)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nasty bug here! repeated clicking causes dwindle to nothing
//        self.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
//        self.tabBarItem.landscapeImagePhoneInsets = UIEdgeInsetsMake(1,1,1,1)

        func f() {
            let h = self.tabBarController!.tabBar.bounds.size.height
            print(h)
            let vc = self.tabBarController!.childForScreenEdgesDeferringSystemGestures
            print("child for screen edges", vc as Any)
        }
        f()
        NotificationCenter.default.addObserver(
        forName: UIApplication.didChangeStatusBarOrientationNotification,
        object: nil, queue: nil) { _ in
            f()
        }
        

    }
    
    // 49 on iPad, all orientations, side by side
    // 49 on iPhone portrait, over under
    // 32 on iPhone landscape, side by side
    // 49 on iPhone 6 Plus portrait, over under
    // 49 on iPhone 6 Plus landscape, side by side
    
}

