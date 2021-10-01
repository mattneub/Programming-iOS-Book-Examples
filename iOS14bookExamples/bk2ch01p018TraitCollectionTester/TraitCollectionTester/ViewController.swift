

import UIKit

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description: String {
        return {
            switch self {
            case .unspecified: return "unspecified"
            case .regular: return "regular"
            case .compact: return "compact"
            @unknown default: // new in Swift 5 have to cover this
                fatalError()
            }
        }()
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let tc = self.traitCollection
        print ("horizontal:", tc.horizontalSizeClass)
        print ("vertical:", tc.verticalSizeClass)
        print ("scale:", tc.displayScale)
    }
    
    /*
     
     iPhone 6s:         ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 2.0
     iPhone 8 Plus:     ↔︎ compact, ↕︎ regular; ↔︎ regular, ↕︎ compact; 3.0
     iPhone X:          ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 3.0
     iPhone XR:         ↔︎ compact, ↕︎ regular; ↔︎ regular, ↕︎ compact; 2.0
     iPhone XS:         ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 3.0
     iPhone XS Max:     ↔︎ compact, ↕︎ regular; ↔︎ regular, ↕︎ compact; 3.0
     iPhone 11:         ↔︎ compact, ↕︎ regular; ↔︎ regular, ↕︎ compact; 2.0
     iPhone 11 Pro:     ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 3.0
     iPhone 11 Pro Max: ↔︎ compact, ↕︎ regular; ↔︎ regular, ↕︎ compact; 3.0
     iPhone 12:         ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 3.0
     iPhone 12 Pro:     ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 3.0
     iPhone 12 Pro Max: ↔︎ compact, ↕︎ regular; ↔︎ regular, ↕︎ compact; 3.0
     iPhone 12 mini:    ↔︎ compact, ↕︎ regular; ↔︎ compact, ↕︎ compact; 3.0

     The iPads are all

     iPad: ↔︎ regular, ↕︎ regular; ↔︎ regular, ↕︎ regular; 2.0


     So, the XR and XS Max are like the Plus models as far as size classes go.
     The iPhone 11 and iPhone 11 Pro Max are also "big" iPhones.
     The iPhone 12 Pro Max is a "big" iPhone.
     
     */


}

