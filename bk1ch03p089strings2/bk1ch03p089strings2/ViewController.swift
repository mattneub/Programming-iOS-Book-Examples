

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let s = "hello world"
            let s2 = s.capitalizedString // "Hello World"
            print(s2)
        }

        do {
            let s = "hello"
            let range = s.rangeOfString("ell") // Optional(Range(1..<4))
            print(range)
        }
        
        do {
            let s = "hello"
            let range = (s as NSString).rangeOfString("ell") // (1,3), an NSRange
            print(range)
        }
        
        do {
            let s = "hello"
            // let ss = s.substringWithRange(NSMakeRange(1,3)) // compile error
            let ss = (s as NSString).substringWithRange(NSMakeRange(1,3))
            print(ss)
        }
        
    }


}

