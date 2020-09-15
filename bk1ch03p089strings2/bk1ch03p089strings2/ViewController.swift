

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let s = "hello world"
            let s2 = s.capitalized // "Hello World"
            print(s2)
        }

        do {
            let s = "hello"
            let range = s.range(of:"ell") // Optional(Range(1..<4))
            print(range as Any)
            let s2 = s[range!]
            print(s2)
        }
        
        do { // cast is not needed in Swift 4
            let s = "hello"
            let range = (s as NSString).range(of:"ell") // (1,3), an NSRange
            print(range) // why have they lost the ability to show me an NSRange?
            // Aha, they brought back the ability, no need for the next line
            // print(NSStringFromRange(range))
        }
        
        do { // cast is not needed in Swift 4
            let s = "hello"
            // let sss = s.substring(with:NSMakeRange(1,3)) // compile error
            // let ssss = s.substring(with:1...3)
            // let sssss = s.substring(with: NSRange(location: 1,length: 3))
            let ss = (s as NSString).substring(with: NSRange(location: 1,length: 3))
            print(ss)
        }
        
        do { // if an NSRange comes from an NSString, use Range.init(_:in:) to get the Range
            let range = NSRange(location: 1, length: 3)
            let r = Range(range, in:"hello")
            print(r as Any)
        }
        
        // New in Swift 4, get the NSRange without casting to NSString!
        do {
            let s = "hello"
            let range = NSRange(s.range(of:"ell")!, in: s)
            print(range) // {1,3}, an NSRange
        }
        
        // New in Swift 4, slice right into the string to get a substring
        do {
            let s = "hello"
            // but you still can't do it with integers!
            // let ss = s[1...3]
            // you have to calculate using string indexes
            let ss = s[s.index(s.startIndex, offsetBy: 1)...s.index(s.startIndex, offsetBy: 3)]
            print(ss)
        }
        
    }


}

