

import UIKit

/*

I can think of various ways we can wind up launching into landscape:

* We accept any orientation, but the device happens to be in landscape at launch time

* The app (.plist) accepts only landscape

* The app (.plist) accepts any orientation, but landscape is first

* The app accepts any orientation, but the view controller restricts it to landscape

*/

class ViewController: UIViewController, UINavigationControllerDelegate {
    
//    override func supportedInterfaceOrientations() -> Int {
//        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
//    }
    
//    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController!) -> Int {
//        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController.delegate = self
        println("viewDidLoad")
        println("viewDidLoad reports \(self.view.bounds.size)")
        println("viewDidLoad reports \(self.traitCollection)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("will appear \(self.view.bounds.size)")
    }
    
    override func viewWillLayoutSubviews() {
        println("willLayout  \(self.view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        println("didLayout \(self.view.bounds.size)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("did appear \(self.view.bounds.size)")
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("willTransition")
        println(newCollection)
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("willTransition")
        println(size)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        println("trait collection did change")
    }

}

/*

normal launch into portrait:

viewDidLoad, portrait view, portrait trait collection
(will appear)
trait collection did change
(willLayout)
(didLayout)
(did appear)

normal launch with device at landscape:

viewDidLoad, portrait view, portrait trait collection
trait collection did change (and the others)
will transition to portrait
will transition to landscape view size
trait collection did change
did/will layout, possibly several times...

app accepts only landscape:

viewDidLoad, landscape view, landscape trait collection
trait collection did change (and the others)
=> so, in this case, we do not start with portrait and then rotate!

app accept any, but landscape is first, and device is held in landscape:

viewDidLoad, landscape view, landscape trait collection
trait collection did change (and the others)

app accepts any, but landscape is first, but device is held in portrait:

viewDidLoad, landscape view, landscape trait collection
trait collection did change (and the others)
will transition to portrait
will transition to portrait view size
trait collection did change
(layout)

app accepts any, portrait is first, but view controller is landscape only, device is held in landscape or portrait, doesn't matter

// MESS (bug? not sure) - fixed in seed 4!
viewDidLoad, portrait view, portrait trait collection
trait collection did change (others)
will transition to landscape trait collection
(no view size change notification?)
trait collection did change
(layout in landscape)


app accepts any, landscape is first, view controller is landscape only, device is held in landscape or portrait

viewDidLoad, landscape view, landscape trait collection
trait collection did change (others)
(will transition to landscape view size, if device was in landscape orientation but it was the wrong one)

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

