

import UIKit

func f (i1:Int, i2:Int) -> () {}
func f2 (#i1:Int, #i2:Int) -> () {}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var pair : (Int, String)
        pair = (1, "One")
        
        var pair2 = (1, "One")
        
        var ix: Int
        var s: String
        (ix, s) = (1, "One")
        
        let (ixx, ss) = (1, "One") // can use let or var here
        
        var s1 = "Hello"
        var s2 = "world"
        (s1, s2) = (s2, s1) // now s1 is "world" and s2 is "Hello"
        
        let pair3 = (1, "One")
        let (_, s3) = pair3 // now s3 is "One"
        
        for (ix,c) in enumerate(s) {
            println("character \(ix) is \(c)")
        }
        
        let ixxx = pair.0 // now ixxx is 1
        pair.0 = 2 // now pair is (2, "One")
        
        if true {
            var pair : (first:Int, second:String) = (1, "One")
        }
        
        if true {
            var pair = (first:1, second:"One")
        }
        
        if true {
            var pair = (first:1, second:"One")
            let x = pair.first // 1
            pair.first = 2
            let y = pair.0 // 2
        }
        
        if true {
            var pair = (1, "One")
            var pairWithNames : (first:Int, second:String) = pair
            let ix = pairWithNames.first // 1
        }
        
        // parameter list in function call is actually a tuple
        
        let p = (1,2)
        f(p)

        let p2 = (i1:1, i2:2)
        f2(p2)

        
        
    }
    
    
    
}

