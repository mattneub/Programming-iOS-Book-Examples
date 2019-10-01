
import UIKit
import CoreText

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    @IBOutlet var lab2 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let f = UIFont(name: "GillSans-BoldItalic", size: 20)!
        let d = f.fontDescriptor
        let vis = d.object(forKey:.visibleName)!
        print(vis)
        let traits = d.symbolicTraits
        let isItalic = traits.contains(.traitItalic)
        let isBold = traits.contains(.traitBold)
        print(isItalic, isBold)
        
        var which : Int { return 0 }
        
        switch which {
        case 0:
            let desc = UIFontDescriptor(name:"Didot", size:18)
            // print(desc.fontAttributes())
            let d = [
                UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
            ]
            let desc2 = desc.addingAttributes([.featureSettings:[d]])
            let f = UIFont(descriptor: desc2, size: 0)
            self.lab.font = f
        case 1:
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
            // print(desc.fontAttributes())
            let d = [
                UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
            ]
            let desc2 = desc.addingAttributes([.featureSettings:[d]])
            let f = UIFont(descriptor: desc2, size: 0)
            self.lab.font = f
        default:break
        }
        
        
        // =========
        
        do {
            
            var whichh : Int { return 1 }

            switch whichh {
            case 0:
                let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
                let d = [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kStylisticAlternativesType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kStylisticAltOneOnSelector
                ]
                let desc2 = desc.addingAttributes([.featureSettings:[d]])
                let f = UIFont(descriptor: desc2, size: 0)
                
                self.lab2.font = f
                self.lab2.text = "1234567890 Hill IO" // notice the straight 6 and 9

            case 1:
                let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
                let d = [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kStylisticAlternativesType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kStylisticAltSixOnSelector
                ]
                let desc2 = desc.addingAttributes([.featureSettings:[d]])
                let f = UIFont(descriptor: desc2, size: 0)
                
                self.lab2.text = "1234567890 Hill IO" // adds curvy ell, barred I, slashed zero
                self.lab2.font = f


            default:break
            }
            
//            let mas = NSMutableAttributedString(string: "offloading fistfights", attributes: [
//                .font:UIFont(name: "Didot", size: 20)!,
//                .ligature:0
//                ])
//            self.lab2.attributedText = mas
            
//            self.lab2.font = UIFont(name: "Papyrus", size: 20)
//            self.lab2.text = "offloading fistfights"
            
            do {
                let desc = UIFontDescriptor(name: "Didot", size: 20) as CTFontDescriptor
                let f = CTFontCreateWithFontDescriptor(desc,0,nil)
                let arr = CTFontCopyFeatures(f)
                print("Didot features:")
                print(arr as Any)
                
                
            }
        
        }
    }
    
    
    @IBAction func doFont(_ sender: Any) {
        let config = UIFontPickerViewController.Configuration()
        // config.displayUsingSystemFont = true
        // config.includeFaces = true
        // config.filteredTraits = [.classSansSerif]
        let picker = UIFontPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated:true)
    }
    
}

extension ViewController : UIFontPickerViewControllerDelegate {
    func fontPickerViewControllerDidCancel(_ vc: UIFontPickerViewController) {
        print("cancel")
    }

    
    func fontPickerViewControllerDidPickFont(_ vc: UIFontPickerViewController) {
        print(vc.selectedFontDescriptor as Any)
        // automatically dismisses
    }
}
