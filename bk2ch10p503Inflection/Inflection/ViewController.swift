

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = 10
        let s : StringLocalizationKey = "You have ^[\(count) \("apple")](inflect: true)."
        let attrib = AttributedString(localized:s)
        let string = String(attrib.characters)
        print(string) // You have 10 apples.
    }


}

