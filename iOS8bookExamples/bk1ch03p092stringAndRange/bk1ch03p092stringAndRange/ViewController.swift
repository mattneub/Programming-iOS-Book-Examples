

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        var s = "hello"
        var arr = Array(s)
        let c = arr[1]

        // let c2 = s[1] // compile error

    
        let ix = s.startIndex
        let ix2 = advance(ix,1)
        let c3 = s[ix2] // "e"

        s.splice("ey, h", atIndex: ix2) // "hey, hello"
        println(s)
        
        let ss = "Ha\u{030A}kon"
        println(count(ss)) // 5
        let length = (ss as NSString).length // or: 
        let length2 = count(ss.utf16)
        println(length) // 6

        let r = 1...3
        let r2 = -1000...(-1)
        for ix in 1 ... 3 {
            println(ix) // 1, then 2, then 3
        }
        let d = 2.1 // ... a Double ...
        if (0.1...0.9).contains(d) {} // ...

        let result = arr[1...3]
        let s2 = String(result)
        
        if true {
            let s = "hello"
            let ix1 = advance(s.startIndex,1)
            let ix2 = advance(ix1,2)
            let r = ix1...ix2
            let s2 = s[r] // "ell"
            println(s2)
        }
        
        if true {
            let s = "hello"
            let ix = advance(s.startIndex,1)
            let ix2 = advance(ix,2)
            let ss = s.substringWithRange(ix...ix2) // "ell"
            println(ss)
        }
        
        if true {
            var s = "hello"
            let ix1 = advance(s.startIndex,1)
            let ix2 = advance(ix1,2)
            let r = ix1...ix2
            s.replaceRange(r, with: "ipp") // s is now "hippo"
            println(s)
        }

        if true {
            var s = "hello"
            let ix1 = advance(s.startIndex,1)
            let ix2 = advance(ix1,2)
            let r = ix1...ix2
            s.removeRange(r) // s is now "ho"
            println(s)
        }


    }


}

