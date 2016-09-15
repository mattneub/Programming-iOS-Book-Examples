

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
            print("someone called the color getter")
            return UIColor.redColor()
        }
        set {
            print("someone called the color setter")
        }
    }
    
    // in Swift 1.2, this works:
    /*
    var color2 : UIColor {
        @objc(hue) get {
            print("someone called the color2 getter")
            return UIColor.redColor()
        }
        @objc(setHue:) set {
            print("someone called the color2 setter")
        }
    }
*/
    // but there is, in Swift 2.0, a simpler way:
    
    @objc(hue) var color2 : UIColor {
        get {
            print("someone called the color2 getter")
            return UIColor.redColor()
        }
        set {
            print("someone called the color2 setter")
        }
    }

    
    var color3 : UIColor?
    
    // these are compile errors, because they attempt to implement the accessors
    
//    func color3() -> UIColor? {
//        return self.color3
//    }
//    
//    func setColor3(c:UIColor?) {
//        self.color3 = c
//    }


    @objc(couleur) var color4 : UIColor?  {
        didSet {
            print("someone set couleur")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Thing().test()
        Thing().test2()
        Thing().test3()
        
        let obj = NSObject()
        // uncomment the next line to crash
        // obj.setValue("howdy", forKey:"keyName") // crash

        let d = Dog()
        d.setValue("Fido", forKey:"name") // no crash!
        print(d.name) // "Fido" - it worked!

        let c = self.valueForKey("hue") as? UIColor // "someone called the getter"
        print(c) // Optional(UIDeviceRGBColorSpace 1 0 0 1)
        
        let myObject = MyClass()
        let arr = myObject.valueForKeyPath("theData.name") as! [String]
        print(arr)
        do {
            let arr : AnyObject = myObject.valueForKey("pepBoys")!
            print(arr)
            let arr2 : AnyObject = myObject.valueForKeyPath("pepBoys.name")!
            print(arr2)
        }
        
        _ = obj
        

        
    }



}

