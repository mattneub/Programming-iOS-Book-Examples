

import UIKit

class Dog {
    func say(s:String, times:Int = 1) {
        for _ in 1...times {
            print(s)
        }
    }
}

func doThing (a a:Int = 0, b:Int = 3) {}

// variadic

func sayStrings(arrayOfStrings:String ...) {
    for s in arrayOfStrings { print(s) }
}

// new in beta 6, variadic can go anywhere

func sayStrings(arrayOfStrings:String ..., times:Int) {
    for _ in 1...times {
        for s in arrayOfStrings { print(s) }
    }
}

// ignored

func say(s:String, times:Int, loudly _:Bool) {Dog().say(s, times:times)}

func say2(s:String, times:Int, _:Bool) {Dog().say(s, times:times)}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let d = Dog()
        d.say("woof") // same as saying d.say("woof", times:1)
        d.say("woof", times:3)
        
        doThing(b:5, a:10) // legal but don't

        sayStrings("hey", "ho", "nonny nonny no")
        
        sayStrings("Mannie", "Moe", "Jack", times:3)
        
        // print is now variadic
        
        print("Mannie", 3, true) // Mannie 3 true
        
        print("Mannie", "Moe", separator:", ", terminator: ", ")
        print("Jack")

        say("hi", times:3, loudly:true)
        
        say2("hi", times:3, true)

    }


}

