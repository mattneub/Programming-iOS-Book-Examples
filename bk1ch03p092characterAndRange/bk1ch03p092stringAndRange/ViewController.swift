

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the term .characters is deleted throughout for Swift 4
        
        do {
            let s = "hello"
            for c in s {
                print(c) // print each Character on its own line
            }
        }
        
        do { // demonstrates what appears to me to be a bug in the new Character unicodeScalars property
            // except that in beta 3 the bug is now in the String property????
            // https://bugs.swift.org/browse/SR-5401
            // bug fixed! beta 5
            let c = Character("a\u{030A}")
            print(c)
            print(String(c).count)
            for sc in c.unicodeScalars {
                print(sc.utf16)
            }
            for sc in String(c).unicodeScalars {
                print(sc.utf16)
            }
            for sc in Array(c.unicodeScalars) {
                print(sc.utf16)
            }
            var i = String(c).unicodeScalars.makeIterator()
            print(i.next()!.value)  //
            print(i.next()!.value)  //
            var ii = c.unicodeScalars.makeIterator()
            print(ii.next()!.value)  //
            print(ii.next()!.value)  //

        }
        
        do {
            let c = Character("h")
            print(c)
            // let ss = c.uppercased()
            let s = (String(c)).uppercased()
            print(s)
        }
        
        // the old way
        /*
        do {
            let moi = "Matt Neuburg"
            let moichars = moi.characters
            let sp = moichars.index(of:" ")!
            // it was possible to take a range of a string rather than a character view...
            // ...but you could do the character view as well
            let firstnamechars = moichars[moichars.startIndex..<sp]
            let firstname = String(firstnamechars)
            print(firstnamechars)
            print(firstname)
        }
        
        // more old way
        
        do {
            let s = "hello"
            let schars = s.characters
            let ell = Character("l")
            let s2chars = schars.filter {$0 != ell}
            let s2 = String(s2chars)
            print(s2)
        }
 */
        
        // the new way to do that
        
        do {
            let s = "hello"
            let ell = Character("l")
            let s2 = s.filter {$0 != ell}
            print(s2)
        }
        
        
        do {
            let s = "hello"
            let c1 = s.first
            let c2 = s.last
            print(c1 as Any, c2 as Any)
        }
        
        do {
            let s = "hello"
            let firstL = s.firstIndex(of:"l")
            print(firstL as Any) // Optional(2), meaning the third character
            let lastL = String(s.reversed()).firstIndex(of:"l")
            print(lastL as Any)
            // haha, but we no longer need that trick
            let lastL2 = s.lastIndex(of:"l")
            print(lastL2 as Any)
        }
        
        do {
            let s = "hello"
            let firstSmall = s.index {$0 < "f"}
            print(firstSmall) // 9223372036854775807! bug in Swift 4????
            // there's a bug where if you don't say `where` explicitly...
            // ...the compiler thinks this is `index(ofAccessibilityElement:)` and you get a weird answer
        }
        
        // but the new firstIndex doesn't have that problem
        do {
            let s = "hello"
            let firstSmall = s.firstIndex {$0 < "f"}
            print(firstSmall as Any)
        }
        
        do {
            let s = "hello"
            let ok = s.contains("o") // true
            print(ok)
        }
        
        do {
            let s = "hello"
            let ok = s.contains {"aeiou".contains($0)} // true
            print(ok)
        }
        
        do {
            let s = "hello"
            let s2 = s.filter {"aeiou".contains($0)}
            print(s2) // "eo"
        }
        
        do {
            let s = "hello"
            let ok = s.starts(with: "hell")
            print(ok)
        }

        do {
            var s = "hello"
            let s2 = s.dropFirst()
            print(s2)
            print(s2.startIndex)
            // s = s2
            s = String(s2)
        }
        
        do {
            var s = "hello"
            s = String(s.prefix(4)) // "hell"
            print(s)
        }
        
        do {
            let s = "hello world"
            let arra = s.split{$0 == " "}
            print(arra)
            print(type(of:arra[0]))
            let arr = s.split{$0 == " "}.map{String($0)}
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
            let s = "hello"
            let s2 = s.dropFirst()
            let last = s2.firstIndex(of:"o")
            print(last as Any) // 4, not 3
        }
        
        do {
            var s = "hello"
            let ix = s.index(s.startIndex, offsetBy:1)
            // "splice" is now "insertContentsOf"
            s.insert(contentsOf:"ey, h", at: ix)
            print(s)
        }
        
        do {
            var s = "hello"
            var s2 = s.dropLast()
            let ix = s2.startIndex
            s2.insert(contentsOf:"s", at:ix)
            do {
                let ix = s.index(s.startIndex, offsetBy:1)
                s.insert(contentsOf:"ey, h", at: ix)
            }
            print(s2)
            print(s)
            print(type(of:s2))
            // I presume what happens here is that the original "hello" lives on as storage for s2,
            // but independently of the pointer "s"
        }
        
        do {
            let s = "Ha\u{030A}kon"
            print(s.count) // 5
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
            // let arr = Array(s.characters) // need this one :)
            let arr = Array(s) // in Swift 4.1 this is the array of characters!
            let result = arr[1...3]
            let s2 = String(result)
            print(s2)
        }
        
        do {
            let s = "hello"
            let r = s.range(of:"ell") // a Swift Range (wrapped in an Optional)
            print(r as Any)
            print(r?.lowerBound as Any) // no longer called startIndex for a Range
        }
        
        do {
            let s = "hello"
            let ix1 = s.index(s.startIndex, offsetBy:1)
            let ix2 = s.index(ix1, offsetBy:3)
            let r = ix1...ix2
            // can't get this conversion to work (range must be open, not closed)
            // let r2 = Range<String.CharacterView.Index>(r)
            // let r3 = Range(r)
            _ = r
            let r2 = ix1..<ix2
            //let r3 = Range(r2) // no problem
            // okay, now it _IS_ a problem
            // but we don't actually need to do it because it's already a Range
            //_ = r3
        }
        
        
        do {
            let s = "hello"
            let ix1 = s.index(s.startIndex, offsetBy:1)
            let ix2 = s.index(ix1, offsetBy:2)
            // can subscript with either type
            let s2 = s[ix1...ix2] // "ell"
            print(s2)
            let s3 = s[ix1..<ix2] // "el"
            print(s3)
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
        
        do { // example of a partial range
            let s = "hello"
            let ix2 = s.index(before: s.endIndex)
            let s2 = s[..<ix2] // "hell"
            print(s2)
        }
        
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
            let r = 2..<4
            let nsr = NSRange(r)
            print(nsr) // {2,2}
            
            let nsr2 = NSRange(location: 2, length: 2)
            let r2 = Range.init(nsr2) // NB this change! toRange is deprecated
            print(r2 as Any) // Optional(Range(2..<4))
        }
        
        do {
            // this is actually from later in the book, just testing
            var s = "hello"
            s.append(contentsOf: Array(" world")) // "hello world"
            s.append(contentsOf: ["!" as Character, "?" as Character])
        }
 
        
    }


}

