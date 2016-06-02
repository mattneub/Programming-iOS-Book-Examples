

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
            let s = (String(c)).uppercased()
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
            let firstL = s.characters.index(of:"l")
            print(firstL) // Optional(2), meaning the third character
            let lastL = String(s.characters.reversed).characters.index(of:"l")
            print(lastL)
        }
        
        do {
            let s = "hello"
            let firstSmall = s.characters.index {$0 < "f"}
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
            let ok = s.characters.starts(with: "hell".characters)
            print(ok)
        }

        do {
            let s = "hello"
            let s2 = String(s.characters.dropFirst())
            print(s2)
        }
        
        do {
            let s = "hello"
            let s2 = String(s.characters.prefix(4)) // "hell"
            print(s2)
        }
        
        do {
            let s = "hello world"
            let arra = s.characters.split{$0 == " "}
            print(arra)
            print(arra[0].dynamicType)
            let arr = s.characters.split{$0 == " "}.map{String($0)}
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
            let ix2 = s.index(ix, offsetBy:1)
            // notion of "advance" now replaced by index after and index offset by
            let c = s[ix2] // "e"
            print(c)
        }
        

        
        do {
            let s = "hello"
            let ix = s.startIndex
            let c = s[s.index(after:ix)] // "e"
            print(c)
        }
        
        do {
            var s = "hello"
            let ix = s.index(s.startIndex, offsetBy:1)
            // "splice" is now "insertContentsOf"
            s.insert(contentsOf:"ey, h".characters, at: ix)
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
        let _ = -1000 ... -1
        // let _ = 3...1 // legal but you'll crash
        
        for ix in 1...3 {
            print(ix) // 1, then 2, then 3
        }
        
        for ix in (1...3).reversed() {
            print(ix)
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
            let r = s.range(of:"ell") // a Swift Range (wrapped in an Optional)
            print(r)
            print(r?.lowerBound) // no longer called startIndex for a Range
        }
        
        do {
            let s = "hello"
            let ix1 = s.index(s.startIndex, offsetBy:1)
            let ix2 = s.index(ix1, offsetBy:3)
            let r = ix1...ix2
            // can't get this conversion to work
            // let r2 = Range<String.CharacterView.Index>(r)
            // let r3 = Range(r)
        }
        
        
        do {
            let s = "hello"
            let ix1 = s.index(s.startIndex, offsetBy:1)
            let ix2 = s.index(ix1, offsetBy:2)
            // interesting thing happens here: we can no longer subscript by a closed range
            // must form the open range version instead
            let s2 = s[ix1...ix2] // "ell"
            print(s2)
        }
        
        // cutting this whole approach; indexes doesn't give a mutable range any more
        
        /*
        
        do {
            let s = "hello"
            var r = s.characters.indices
            r.startIndex = r.index(after:r.startIndex)
            r.endIndex = r.index(before:r.endIndex)
//            let s2 = s[r] // "ell"
//            print(s2)
        }
 
 */
        
        
        do {
            var s = "hello"
            let ix = s.startIndex
            let r = s.index(ix, offsetBy:1)...s.index(ix, offsetBy:3)
            s.replaceSubrange(r, with: "ipp") // s is now "hippo"
            print(s)
        }
        

        
        do {
            var s = "hello"
            let ix = s.startIndex
            let r = s.index(ix, offsetBy:1)...s.index(ix, offsetBy:3)
            s.removeSubrange(r) // s is now "ho"
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

