

import UIKit

// demonstrating a new Xcode 6 feature: 
// conditional constraints (using size classes) in Interface Builder
// we have our base set of constraints on iPad
// another set (based on that) for iPhone portrait
// another set (based on that) iPhone landscape

// results on iPhone 6 Plus are kind of weird because it thinks it's an iPad in landscape!
// if you don't want, that you have to special-case that situation (horiz regular, vertical compact)
// or wrap it in a container controller

class ViewController: UIViewController {


}
