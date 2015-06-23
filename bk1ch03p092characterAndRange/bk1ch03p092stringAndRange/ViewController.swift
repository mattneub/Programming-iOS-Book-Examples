

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let s = "hello"
            for c in s.characters {
                print(c) // print each Character on its own line
            }
        }
        
        do {
            let c = Character("h")
            print(c)
            let s = (String(c)).uppercaseString
            print(s)
        }
        
        do {
            let s = "hello"
            let c1 = s.characters.first
            let c2 = s.characters.last
            print(c1,c2)
        }
        
        do {
            let s = "hello"
            let firstL = s.characters.indexOf("l")
            print(firstL) // Optional(2), meaning the third character
            let lastL = String(s.characters.reverse()).characters.indexOf("l")
            print(lastL)
        }
        
        do {
            let s = "hello"
            let firstSmall = s.characters.indexOf {$0 < "f"}
            print(firstSmall)
        }
        
        do {
            let s = "hello"
            let ok = s.characters.contains("o") // true
            print(ok)
        }
        
        do {
            let s = "hello"
            let ok = s.characters.contains {"aeiou".characters.contains($0)} // true
            print(ok)
        }
        
        do {
            let s = "hello"
            let s2 = String(s.characters.filter {"aeiou".characters.contains($0)})
            print(s2) // "eo"
        }
        
        do {
            let s = "hello"
            let ok = s.characters.startsWith("hell".characters)
            print(ok)
        }

        do {
            let s = "hello"
            let s2 = String(dropLast(s.characters))
            print(s2)
        }
        
        do {
            let s = "hello"
            let s2 = String(prefix(s.characters,4)) // "hell"
            print(s2)
        }
        
        do {
            let s = "hello world"
            let arr = split(s.characters) {$0 == " "}.map{String($0)}
            print(arr)
        }
        
        do {
            let s = "hello"
            // let c = s[1] // compile error
            // let c = s.characters[1] // compile error
            print(s)
        }
        
        do {
            let s = "hello"
            let ix = s.startIndex
            let c = s[advance(ix,1)] // "e"
            print(c)
        }
        
        do {
            let s = "hello"
            var ix = s.startIndex
            let c = s[++ix] // "e"
            print(c)
        }

        
        do {
            let s = "hello"
            let ix = s.startIndex
            let c = s[ix.successor()] // "e"
            print(c)
        }
        
        do {
            var s = "hello"
            let ix = advance(s.characters.startIndex, 1)
            s.splice("ey, h".characters, atIndex: ix)
            print(s)
        }
        
        do {
            let s = "Ha\u{030A}kon"
            print(s.characters.count) // 5
            let length = (s as NSString).length // or:
            let length2 = s.utf16.count
            print(length, length2) // 6
        }
        
        let _ = 1...3
        let _ = -1000...(-1)
        // let _ = 3...1 // legal but you'll crash
        
        for ix in 1 ... 3 {
            print(ix) // 1, then 2, then 3
        }
        
        do {
            let d = 2.1 // ... a Double ...
            if (0.1...2.9).contains(d) {
                print("yes it does")
            }
        }
        
        do {
            let s = "hello"
            let arr = Array(s.characters)
            let result = arr[1...3]
            let s2 = String(result)
            print(s2)
        }
        
        do {
            let s = "hello"
            let r = s.rangeOfString("ell") // a Swift Range (wrapped in an Optional)
            print(r)
        }
        
        do {
            let s = "hello"
            let ix1 = advance(s.startIndex,1)
            let ix2 = advance(ix1,2)
            let s2 = s[ix1...ix2] // "ell"
            print(s2)
        }
        
        do {
            let s = "hello"
            var r = s.characters.indices
            r.startIndex++
            r.endIndex--
            let s2 = s[r] // "ell"
            print(s2)
        }
        
        /*
        
        do {
            let s = "hello"
            var r = s.characters.indices
            r.startIndex++
            r.endIndex--
            let s2 = s.substringWithRange(r) // "ell"
            print(s2)
        }

*/
                
        do {
            var s = "hello"
            let ix = s.startIndex
            let r = advance(ix,1)...advance(ix,3)
            s.replaceRange(r, with: "ipp") // s is now "hippo"
            print(s)
        }
        
        do {
            var s = "hello"
            let ix = s.startIndex
            let r = advance(ix,1)...advance(ix,3)
            s.removeRange(r) // s is now "ho"
            print(s)
        }
        
        do {
            let r = NSRange(2..<4)
            print(r)
            let r2 = r.toRange()
            print(r2)
        }
        
    }


}

