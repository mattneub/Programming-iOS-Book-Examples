

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let s = "hello world"
        let s2 = s.capitalizedString // "Hello World"

        let range = s.rangeOfString("ell") // Optional(Range(1..<4))
        let range2 = (s as NSString).rangeOfString("ell") // (1,3), an NSRange

        // let ss = s.substringWithRange(NSMakeRange(1,3)) // compile error
        let ss2 = (s as NSString).substringWithRange(NSMakeRange(1,3))

        let ok = contains(s,"o") // true
        let ok2 = contains(s){contains("aeiou",$0)} // true
        let ix = find(s,"o") // 4, wrapped in an Optional
        let sss2 = prefix(s,4) // "hell"
        let arr = split(s) {contains("aeiou ", $0)} // ["h", "ll", "w", "rld"]
        let arr2 = split(s, maxSplit:1) {contains("aeiou ", $0)} // ["h", "llo world"]

        let c = Character("h")
        let c2 = Character(UnicodeScalar(0x68))

        let ssss = "hello"
        var arrrr = Array(ssss)
        arrrr.removeLast()
        let ssss2 = String(arrrr) // "hell"

        


    }


}

