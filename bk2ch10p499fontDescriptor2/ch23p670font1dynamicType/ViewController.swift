
import UIKit
// import CoreText // no longer necessary to import core text

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    @IBOutlet var lab2 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let desc = UIFontDescriptor(name:"Didot", size:18)
        // print(desc.fontAttributes())
        let d = [
            UIFontFeatureTypeIdentifierKey:kLetterCaseType,
            UIFontFeatureSelectorIdentifierKey:kSmallCapsSelector
        ]
        let desc2 = desc.fontDescriptorByAddingAttributes(
            [UIFontDescriptorFeatureSettingsAttribute:[d]]
        )
        let f = UIFont(descriptor: desc2, size: 0)
        self.lab.font = f
        
        // =========
        
        do {
        
            var f = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
            
            let desc = f.fontDescriptor()
            let d = [
                UIFontFeatureTypeIdentifierKey:kStylisticAlternativesType,
                UIFontFeatureSelectorIdentifierKey:kStylisticAltOneOnSelector
            ]
            let desc2 = desc.fontDescriptorByAddingAttributes(
                [UIFontDescriptorFeatureSettingsAttribute:[d]]
            )
            f = UIFont(descriptor: desc2, size: 0)
            
            self.lab2.font = f
            self.lab2.text = "1234567890" // notice the straight 6 and 9
            
//            let mas = NSMutableAttributedString(string: "offloading fistfights", attributes: [
//                NSFontAttributeName:UIFont(name: "Didot", size: 20)!,
//                NSLigatureAttributeName:0
//                ])
//            self.lab2.attributedText = mas
            
//            self.lab2.font = UIFont(name: "Papyrus", size: 20)
//            self.lab2.text = "offloading fistfights"
        
        }
    }
    
    
    
}
