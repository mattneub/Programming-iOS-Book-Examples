

import UIKit

class ViewController : UIViewController {
    
    /*
    The problem is that dynamic type is not actually dynamic!
    Updating the interface is up to you.
*/
    
    @IBOutlet var lab : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doDynamicType:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        // println((UIFont.familyNames() as [String])
        //    .map{UIFont.fontNamesForFamilyName($0)})

    }
    
    func doDynamicType(n:NSNotification) {
        let style = self.lab.font.fontDescriptor().objectForKey(UIFontDescriptorTextStyleAttribute) as String
        self.lab.font = UIFont.preferredFontForTextStyle(style)
    }
    
    
}
