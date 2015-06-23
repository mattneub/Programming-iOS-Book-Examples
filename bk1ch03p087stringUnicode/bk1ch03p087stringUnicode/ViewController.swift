

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

        let s = "\u{a1}hol\u{e1}!"
        print(s)
        for i in s.utf8 {
            print(i) // 194, 161, 104, 111, 108, 195, 161, 33
        }
        for i in s.utf16 {
            print(i) // 161, 104, 111, 108, 225, 33
        }
        
        do {
            let s = flag("DE")
            print(s)
        }

    
    }



}

