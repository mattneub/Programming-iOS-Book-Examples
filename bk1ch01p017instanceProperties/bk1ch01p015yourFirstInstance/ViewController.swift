

import UIKit

class Dog {
    var name = ""
    var whatADogSays = "woof"
    func bark() {
        println(self.whatADogSays)
    }
    func speak() {
        self.bark()
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let dog1 = Dog()
        dog1.name = "Fido"
        var dog2 = Dog()
        dog2.name = "Rover"
        println(dog1.name) // "Fido"
        println(dog2.name) // "Rover"
        dog2 = dog1
        println(dog2.name) // "Fido"
        
        // the magic word "self"
        
        dog1.bark()
        dog1.speak()
        
    }



}

