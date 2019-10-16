

import UIKit

class Dog {
    var name = ""
    var whatADogSays = "woof"
    func bark() {
        print(self.whatADogSays)
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
        print(dog1.name) // "Fido"
        print(dog2.name) // "Rover"
        dog2 = dog1
        print(dog2.name) // "Fido"
        
        // the magic word "self"
        
        dog1.bark()
        dog1.speak()
        
    }



}

