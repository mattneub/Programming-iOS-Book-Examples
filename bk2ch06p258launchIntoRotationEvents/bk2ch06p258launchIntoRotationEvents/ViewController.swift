

import UIKit

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description : String {
        if self == .compact {return "compact"}
        if self == .regular {return "regular"}
        return "unknown"
    }
}

extension UITraitCollection {
    open override var description : String {
        return "\(self.horizontalSizeClass) \(self.verticalSizeClass)"
    }
    open override var debugDescription : String {
        return "\(self.horizontalSizeClass) \(self.verticalSizeClass)"
    }
}

/*

I can think of various ways we can wind up launching into landscape:

* We accept any orientation, but the device happens to be in landscape at launch time

* The app (.plist) accepts only landscape

* The app (.plist) accepts any orientation, but landscape is first

* The app accepts any orientation, but the view controller restricts it to landscape
 

*/

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        // return super.supportedInterfaceOrientations
        return .landscape
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController.delegate = self
        print("viewDidLoad")
        print("viewDidLoad reports \(self.view.bounds.size)")
        print("viewDidLoad reports \(self.traitCollection)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear \(self.view.bounds.size)")
    }
    
    override func viewWillLayoutSubviews() {
        print("willLayout  \(self.view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        print("didLayout \(self.view.bounds.size)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear \(self.view.bounds.size)")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition trait", newCollection)
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition size", size)
        super.viewWillTransition(to: size, with: coordinator)
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change to \(self.traitCollection)")
        super.traitCollectionDidChange(previousTraitCollection)
    }

}

/*

 iOS 15 (iPhone SE 2) [hint: don't forget to turn rotate lock off!]:

 === normal launch into portrait

 viewDidLoad
 viewDidLoad reports (375.0, 667.0)
 viewDidLoad reports compact regular
 will appear (375.0, 667.0)
 willLayout  (375.0, 667.0)
 didLayout (375.0, 667.0)
 did appear (375.0, 667.0)

 === normal launch with device held at landscape

 viewDidLoad
 viewDidLoad reports (667.0, 375.0)
 viewDidLoad reports compact compact
 will appear (667.0, 375.0)
 willLayout  (667.0, 375.0)
 didLayout (667.0, 375.0)
 did appear (667.0, 375.0)

 === app accepts only landscape, even if device is held in portrait
 
 same as previous
 
 === app accepts any, but landscape is first, but device is held in portrait
 
 same as first
 
 ==== app accepts any, but view controller wants landscape
 
 aha. Well, it depends. If the device is held in landscape, just like other landscape cases
 
 but if the device is held in portrait, we launch into portrait and rotate:

 viewDidLoad
 viewDidLoad reports (375.0, 667.0)
 viewDidLoad reports compact regular
 will appear (375.0, 667.0) // proving that will appear can be too early for layout-related
 willTransition trait compact compact
 trait collection did change to compact compact // nb; and note no size change
 willLayout  (667.0, 375.0)
 didLayout (667.0, 375.0)
 willLayout  (667.0, 375.0)
 didLayout (667.0, 375.0)
 did appear (667.0, 375.0)

 // workaround: app accepts landscape only, v.c. wants landscape, app delegate permits all, held in portrait
 works as if held in landscape:

 viewDidLoad
 viewDidLoad reports (667.0, 375.0)
 viewDidLoad reports compact compact
 will appear (667.0, 375.0)
 willLayout  (667.0, 375.0)
 didLayout (667.0, 375.0)
 did appear (667.0, 375.0)

*/

/* 
If we are in, say, navigation interface,
we do not have actual view dimensions until "will appear"
*/

/*
In navigation interface, we can get did layout more than once on rotation...
...and dimensions are not necessarily correct the first time
layout on rotation in that case is *after* the transitions/trait changes
*/

/*
I took out the navigation interface because it confuses the matter for now;
for example, we can launch into portrait even if the navigation controller delegate says no
*/

