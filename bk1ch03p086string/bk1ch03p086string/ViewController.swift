

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let greeting = "hello"
            print(greeting)
            let leftTripleArrow = "\u{21DA}"
            print(leftTripleArrow)
            let n = 5
            let s = "You have \(n) widgets."
            print(s)
        }
        
        do {
            let m = 4
            let n = 5
            let s = "You have \(m + n) widgets."
            print(s)
        }
        
        do {
            let ud = NSUserDefaults.standardUserDefaults()
            // let s = "You have \(ud.integerForKey("widgets")) widgets." // compile error
            let n = ud.integerForKey("widgets")
            let s = "You have \(n) widgets."
            print(s)
        }
        
        do {
            let s = "hello"
            let s2 = " world"
            let greeting = s + s2
            print(greeting)
        }

        do {
            var s = "hello"
            let s2 = " world"
            s.extend(s2) // or: sss += sss2
            print(s)
        }

        do {
            let s = "hello"
            let s2 = "world"
            let space = " "
            let greeting = space.join([s,s2])
            print(greeting)
        }
        
        do {
            print("hello".hasPrefix("he"))
            print("hello".hasSuffix("lo"))
        }

        do {
            let i = 7
            let s = String(i)
            print(s)
        }

        do {
            let i = 31
            let s = String(i, radix:16) // "1f"
            print(s)
        }
        
        do {
            let s = "31"
            let i = Int(s) // Optional(31)
            print(i)
        }
        
        do {
            let s = "31.34"
            let i = Int(s) // nil because it wasn't an Int; you don't get magical double-coercion
            print(i)
        }
        
        do {
            let s = "hello"
            let length = s.characters.count // 5
            print(length)
        }
        
        do {
            let s = "hello"
            for c in s.characters {
                print(c) // print each Character on its own line
            }
        }


    }


}

