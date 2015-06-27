

import UIKit

class Dog {
    var noise : String?
    func speak() -> String? {
        return self.noise
    }
}


class ViewController: UIViewController {
    
    @IBOutlet var myButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

    
        let stringMaybe : String? = "howdy"
        let upper = stringMaybe!.uppercaseString // legal but dangerous
        // let upper2 = stringMaybe.uppercaseString // compile error
        let upper3 = stringMaybe?.uppercaseString
        print(upper3)
        
        let stringMaybe2 : String? = nil
        let upper4 = stringMaybe2?.uppercaseString // no crash!
        print(upper4)
        
        // longer chain - still just one Optional results
        let f = self.view.window?.rootViewController?.view.frame

        let d = Dog()
        let bigname = d.speak()?.uppercaseString

        let s : String? = "Howdy"
        if s == "Howdy" { print("equal") }
        let i : Int? = 2
        if i < 3 { print("less") }

        let arr = [1,2,3]
        let ix = (arr as NSArray).indexOfObject(4)
        if ix == NSNotFound { print("not found") }
        
        let arr2 = [1,2,3]
        let ix2 = arr2.indexOf(4)
        if ix2 == nil { print("not found") }


        _ = upper
        _ = f
        _ = bigname
        
        let v = UIView()
        let c = v.backgroundColor
        // let c2 = c.colorWithAlphaComponent(0.5) // compile error
        let c2 = c?.colorWithAlphaComponent(0.5)
        
        _ = c2


    
    }

}

// they fixed this API!

class MyLayer : CALayer {
    override func drawInContext(ctx: CGContext) {
        //
    }
}

