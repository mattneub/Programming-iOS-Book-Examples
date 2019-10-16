

import UIKit

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description: String {
        return {
            switch self {
            case .unspecified: return "unspecified"
            case .regular: return "regular"
            case .compact: return "compact"
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
     
     iPhone 5s: compact, regular, 2.0; compact, compact, 2.0
     iPhone 8 Plus: compact, regular, 3.0; regular, compact, 3.0
     iPhone X: compact, regular, 3.0; compact, compact, 3.0
     iPhone XR: compact, regular, 2.0; regular, compact, 2.0
     iPhone XS: compact, regular, 3.0; compact, compact, 3.0
     iPhone XS Max: compact, regular, 3.0; regular, compact, 3.0
     
     So, the XR and XS Max are like the Plus models as far as size classes go.
     
     */


}

