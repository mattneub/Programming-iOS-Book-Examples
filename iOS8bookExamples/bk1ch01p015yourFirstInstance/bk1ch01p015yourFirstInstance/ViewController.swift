

import UIKit

class Dog {
    func bark() {
        println("woof")
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fido = Dog()
        fido.bark()

        // Dog.bark() // error: no, it's an _instance_ method
        // think the error message is weird? see the explanation on p. 127
        
    }



}

