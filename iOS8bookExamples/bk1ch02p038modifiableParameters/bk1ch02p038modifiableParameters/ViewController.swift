

import UIKit

func say(s:String, #times:Int, var #loudly:Bool) {
    loudly = true // can't do this without "var"
}

func removeFromString(inout s:String, character c:Character) -> Int {
    var howMany = 0
    while let ix = find(s,c) {
        s.removeRange(ix...ix)
        howMany += 1
    }
    return howMany
}

class Dog {
    var name = ""
}

func changeNameOfDog(d:Dog, to tostring:String) {
    d.name = tostring // no "var", no "inout" needed
}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var s = "hello"
        let result = removeFromString(&s, character:Character("l"))
        println(result)
        println(s) // this is the important part!
        
        // proving that the inout parameter is _always_ changed
        
        var ss = "testing" {didSet {println("did")}}
        removeFromString(&ss, character:Character("X")) // "did", even though no change
        
        // proving that a class instance parameter is mutable in a function without "inout"
        
        let d = Dog()
        d.name = "Fido"
        println(d.name) // "Fido"
        changeNameOfDog(d, to:"Rover")
        println(d.name) // "Rover"

        
    }


}

