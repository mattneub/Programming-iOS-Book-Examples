

import UIKit

class Dog : NSObject {
    var name : String = ""
}

class DogOwner : NSObject {
    var dogs = [Dog]()
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
    // the _ is, uh, really important
    func objectInPepBoysAtIndex(_ ix:Int) -> Any {
        return self.theData[ix]
    }

}


class ViewController: UIViewController {
    
    var color : UIColor {
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

        let d = Dog()
        d.setValue("Fido", forKey:"name") // no crash!
        print(d.name) // "Fido" - it worked!

        let c = self.value(forKey:"hue") as? UIColor // "someone called the getter"
        print(c) // Optional(UIDeviceRGBColorSpace 1 0 0 1)
        
        let myObject = MyClass()
        let arr = myObject.value(forKeyPath:"theData.name") as! [String]
        // NB can't do this, because Swift doesn't know about this path
        // let arr2 = myObject.value(forKeyPath:#keyPath(MyClass.theData.name))
        print(arr)
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

