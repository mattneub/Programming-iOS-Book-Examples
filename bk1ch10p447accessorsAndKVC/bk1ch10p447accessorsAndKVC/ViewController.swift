

import UIKit

class Dog : NSObject {
    var name : String = ""
}

class MyClass : NSObject {
    var theData = [
        [
            "description" : "The one with glasses.",
            "name" : "Manny"
        ],
        [
            "description" : "Looks a little like Governor Dewey.",
            "name" : "Moe"
        ],
        [
            "description" : "The one without a mustache.",
            "name" : "Jack"
        ]
    ]
    func countOfPepBoys() -> Int {
        return self.theData.count
    }
    func objectInPepBoysAtIndex(ix:Int) -> AnyObject {
        return self.theData[ix]
    }

}


class ViewController: UIViewController {
    
    var color : UIColor {
        get {
            println("someone called the getter")
            return UIColor.redColor()
        }
        set {
            println("someone called the setter")
        }
    }
    var color2 : UIColor {
        @objc(hue) get {
            println("someone called the getter")
            return UIColor.redColor()
        }
        @objc(setHue:) set {
            println("someone called the setter")
        }
    }




    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setTranslatesAutoresizingMaskIntoConstraints(
            self.view.translatesAutoresizingMaskIntoConstraints()
        )
        
        Thing().test()
        
        let obj = NSObject()
        // uncomment the next line to crash
        // obj.setValue("howdy", forKey:"keyName") // crash

        var d = Dog()
        d.setValue("Fido", forKey:"name") // no crash!
        println(d.name) // "Fido" - it worked!

        let c = self.valueForKey("hue") as? UIColor // "someone called the getter"
        println(c) // Optional(UIDeviceRGBColorSpace 1 0 0 1)
        
        let myObject = MyClass()
        let arr = myObject.valueForKeyPath("theData.name") as! [String]
        println(arr)
        if true {
            let arr : AnyObject = myObject.valueForKey("pepBoys")!
            println(arr)
            let arr2 : AnyObject = myObject.valueForKeyPath("pepBoys.name")!
            println(arr2)
        }

        
    }



}

