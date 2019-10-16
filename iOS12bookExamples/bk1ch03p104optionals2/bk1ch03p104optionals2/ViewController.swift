

import UIKit

class Dog {
    var noise : String?
    func speak() -> String? {
        return self.noise
    }
}

func doThis(_ f:()->String?) {
    let s = f()
    print(s as Any)
}

func optionalStringMaker() -> String! {
    return Optional("Howdy")
}

// new in Swift 4.1:
// Using '!' in this location is deprecated and will be removed in a future release; consider changing this to '?' instead
// But the previous example is _not_ deprecated, which is a bit weird
/*
func doThis2(_ f:()->String!) {
    let s = f()
    print(s as Any)
}
 */

func doThis2(_ f:()->String?) {
    let s = f()
    print(s as Any)
}


func optionalStringMaker2() -> String? {
    return Optional("Howdy")
}


var ios : String! = "howdy"
var opt : String? = "howdy"

class ViewController: UIViewController {
    
    @IBOutlet var myButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // type substitution works only one way
        doThis(optionalStringMaker)
        // doThis2(optionalStringMaker2) // no
        
        // value substitution, works both ways
        ios = opt
        opt = ios
    
        let stringMaybe : String? = "howdy"
        let upper = stringMaybe!.uppercased() // legal but dangerous
        // let upper2 = stringMaybe.uppercaseString // compile error
        let upper3 = stringMaybe?.uppercased()
        print(upper3 as Any)
        
        let stringMaybe2 : String? = nil
        let upper4 = stringMaybe2?.uppercased() // no crash!
        print(upper4 as Any)
        
        // longer chain - still just one Optional results
        let f = self.view.window?.rootViewController?.view.frame

        let d = Dog()
        let bigname = d.speak()?.uppercased()

        let s : String? = "Howdy"
        if s == "Howdy" { print("equal") }
        
        // becomes illegal in seed 6
        // equality still works with Optional, but comparison does not
//        let i : Int? = 2
//        if i < 3 { print("less") }
        // you can, however, say this (though of course you can crash if i is nil):
        let i : Int! = 2
        if i < 3 { print("less") } // involves forced unwrapping
        
        do {
            let i : Int? = 2
            if i != nil && i! < 3 {
                print("less")
            }
        }
        
        var crash : Bool {return false}
        if crash {
            let c : UIColor! = nil
            if c == .red { // crash at runtime
                print("it is red")
            }
        }


        let arr = [1,2,3]
        let ix = (arr as NSArray).index(of:4) // NSArray method, not Swift
        print(ix)
        if ix == NSNotFound { print("not found") }
        
        let arr2 = [1,2,3]
        let ix2 = arr2.firstIndex(of:4)
        if ix2 == nil { print("not found") }


        _ = upper
        _ = f
        _ = bigname
        
        let v = UIView()
        let c = v.backgroundColor
        // let c2 = c.withAlphaComponent(0.5) // compile error
        let c2 = c?.withAlphaComponent(0.5)
        
        _ = c2

        do {
            // showing what map and flatMap do
            let i : Int? = nil
            let result1 = i.map {_ in "hello"} // String?
            let result2 = i.flatMap {_ in "hello"} // String?
            let result3 = i.map {_ in Optional("hello") } // String??
            let result4 = i.flatMap {_ in Optional("hello") } // String?
        }
        
        do {
            let s : String? = "howdy"
            let s2 = s.map {$0.uppercased()}
        }
        
        do {
            let s : String? = "1"
            let i = s.flatMap {Int($0)}
        }
    
    }
    
}

// they fixed this API!

class MyLayer : CALayer {
    override func draw(in: CGContext) {
        //
    }
}

