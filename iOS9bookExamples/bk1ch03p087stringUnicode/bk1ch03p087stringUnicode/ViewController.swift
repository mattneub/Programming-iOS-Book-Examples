

import UIKit

func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.append(UnicodeScalar(base + v.value))
    }
    return s
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let s = "\u{BF}Qui\u{E9}n?"
        print(s)
        for i in s.utf8 {
            print(i) // 194, 191, 81, 117, 105, 195, 169, 110, 63
        }
        print("---")
        for i in s.utf16 {
            print(i) // 191, 81, 117, 105, 233, 110, 63
        }
        
        do {
            let s = flag("DE")
            print(s)
        }

    
    }



}

