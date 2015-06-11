

import UIKit

class Dog {
    var noise : String? = nil
    func speak() -> String? {
        return self.noise
    }
}


class ViewController: UIViewController {
    
    @IBOutlet var myButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

    
        let stringMaybe : String? = "howdy"
        let upper = stringMaybe!.uppercaseString
        // let upper2 = stringMaybe.uppercaseString // compile error
        let upper3 = stringMaybe?.uppercaseString
        println(upper3)
        
        let stringMaybe2 : String? = nil
        let upper4 = stringMaybe2?.uppercaseString // no crash!
        println(upper4)
        
        // longer chain - still just one Optional results
        let f = self.view.window?.rootViewController?.view.frame

        let d = Dog()
        let bigname = d.speak()?.uppercaseString

        let s : String? = "Howdy"
        if s == "Howdy" { println("equal") }
        let i : Int? = 2
        if i < 3 { println("less") }

        let arr = [1,2,3]
        let ix = (arr as NSArray).indexOfObject(4)
        if ix == NSNotFound { println("not found") }
        
        let arr2 = [1,2,3]
        let ix2 = find(arr2,4)
        if ix2 == nil { println("not found") }


    
    }

}

