

import UIKit

class Dog : NSObject {
    @objc var name : String = ""
}

class DogOwner : NSObject {
    @objc var dogs = [Dog]()
}

//@objc protocol Named {
//    var name : String {get}
//}

class MyClass : NSObject {
    // must mark @objc! otherwise Objective-C can't see this stuff
    @objc var theData = [
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
    @objc func countOfPepBoys() -> Int {
        return self.theData.count
    }
    // the _ is, uh, really important
    @objc func objectInPepBoysAtIndex(_ ix:Int) -> Any {
        return self.theData[ix]
    }
    @objc var theDogs : [Dog] = {
        let d1 = Dog(); d1.name = "Fido"
        let d2 = Dog(); d2.name = "Rover"
        return [d1,d2]
    }()
}


class ViewController: UIViewController {
    
    @objc var color : UIColor { // must expose explicitly
        get {
            print("someone called the color getter")
            return .red
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
            return .red
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
        // won't even compile
        // obj.setValue("howdy", forKey: #keyPath(NSObject.keyName))

        let d = Dog()
        d.setValue("Fido", forKey:"name") // no crash!
        print(d.name) // "Fido" - it worked!
        
        d.setValue("Sandy", forKey:#keyPath(Dog.name))
        
        // no way; cannot substitute Swift keypath for a string
        // d.setValue("Rover", forKey:\Dog.name)
        // can of course use Swift
        d[keyPath:\Dog.name] = "Rover"
        print(d.name)

        let c = self.value(forKey:"hue") as? UIColor // "someone called the getter"
        print(c as Any) // Optional(UIDeviceRGBColorSpace 1 0 0 1)
        
        let myObject = MyClass()
        let arr = myObject.value(forKeyPath:"theData.name") as! [String]
        print(arr)
        // can't do this because Swift doesn't know about this path
        // let arr2 = myObject.value(forKeyPath:#keyPath(MyClass.theData.name))
        let arr3 = myObject.value(forKeyPath:#keyPath(MyClass.theDogs.name))
        print(arr3 as Any)
        
        do {
            let arr = myObject.theData.map {$0["name"]!}
            print(arr)
        }

        do {
            let arr = myObject.value(forKey:"pepBoys")!
            print(arr)
            print(type(of:arr))
            let arr2 = myObject.value(forKeyPath:"pepBoys.name")!
            print(arr2)
            print(type(of:arr2))
        }
        
        _ = obj
        
        print(#selector(setter:color2)) // setHue:
        
        let owner = DogOwner()
        let dog1 = Dog()
        dog1.name = "Fido"
        let dog2 = Dog()
        dog2.name = "Rover"
        owner.dogs = [dog1, dog2]
        let names = owner.value(forKeyPath:#keyPath(DogOwner.dogs.name)) as! [String] // ["Fido", "Rover"]
        let dog1name = dog1.value(forKey:#keyPath(Dog.name)) as! String
        

        print(names)
        print(dog1name)
    }



}

