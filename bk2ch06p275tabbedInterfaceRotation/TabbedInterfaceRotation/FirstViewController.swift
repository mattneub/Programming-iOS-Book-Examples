

import UIKit

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description: String {
        return self == .compact ? "compact" : "regular"
    }
    
    
}

class FirstViewController: UIViewController {

    // see storyboard for image configuration
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.tabBarItem.selectedImage = UIImage(named:"smiley")!
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("horiz", self.traitCollection.horizontalSizeClass)
        print("vert", self.traitCollection.verticalSizeClass)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        self.tabBarItem.landscapeImagePhoneInsets = UIEdgeInsetsMake(1,1,1,1)

        func f() {
            let h = self.tabBarController!.tabBar.bounds.size.height
            print(h)
            let vc = self.tabBarController!.childViewControllerForScreenEdgesDeferringSystemGestures()
            print("child for screen edges", vc as Any)
        }
        f()
        NotificationCenter.default.addObserver(
        forName: .UIApplicationDidChangeStatusBarOrientation,
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

