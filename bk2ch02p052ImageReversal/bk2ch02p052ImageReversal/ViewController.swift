

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // bug in iOS 10 beta 3: this doesn't work if the image is not in asset catalog
        self.iv.image = self.iv.image?.imageFlippedForRightToLeftLayoutDirection()
        
        // using the rest to explore some of the new iOS 10 features
        
        let v1 = self.view.viewWithTag(1)! // playback
        let v2 = self.view.viewWithTag(2)! // nothing, but it's inside 1
        let v3 = self.view.viewWithTag(3)! // forced rtl
        let v4 = self.view.viewWithTag(4)! // nothing, but it's inside 3

        print("semantic content attributes")
        print(v1.semanticContentAttribute.rawValue)
        print(v2.semanticContentAttribute.rawValue)
        print(v3.semanticContentAttribute.rawValue)
        print(v4.semanticContentAttribute.rawValue)
        
        print("trait collection layout directions")
        print(self.view.traitCollection.layoutDirection.rawValue)
        print(v1.traitCollection.layoutDirection.rawValue)
        print(v2.traitCollection.layoutDirection.rawValue)
        print(v3.traitCollection.layoutDirection.rawValue)
        print(v4.traitCollection.layoutDirection.rawValue)
        
        print("user interface layout directions")
        let appdir = UIApplication.shared.userInterfaceLayoutDirection
        print(appdir.rawValue)
        print(v1.effectiveUserInterfaceLayoutDirection.rawValue)
        print(v2.effectiveUserInterfaceLayoutDirection.rawValue)
        print(v3.effectiveUserInterfaceLayoutDirection.rawValue)
        print(v4.effectiveUserInterfaceLayoutDirection.rawValue)
        
        print("UIView.userInterfaceLayoutDirection")
        print(UIView.userInterfaceLayoutDirection(for: v1.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v1.semanticContentAttribute, relativeTo: appdir).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v2.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v2.semanticContentAttribute, relativeTo: appdir).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v3.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v3.semanticContentAttribute, relativeTo: appdir).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v4.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v4.semanticContentAttribute, relativeTo: appdir).rawValue)


    }


}

