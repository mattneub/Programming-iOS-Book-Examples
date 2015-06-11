
import UIKit
// import CoreText // no longer necessary to import core text

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let desc = UIFontDescriptor(name:"Didot", size:18)
        let d = [
            UIFontFeatureTypeIdentifierKey:kLetterCaseType,
            UIFontFeatureSelectorIdentifierKey:kSmallCapsSelector
        ]
        let desc2 = desc.fontDescriptorByAddingAttributes(
            [UIFontDescriptorFeatureSettingsAttribute:[d]]
        )
        let f = UIFont(descriptor: desc2, size: 0)
        self.lab.font = f
    }
    
    
    
}
