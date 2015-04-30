

import UIKit

class Dog {
    func say(s:String, times:Int = 1) {
        for _ in 1...times {
            println(s)
        }
    }
}

func doThing (a:Int = 0, b:Int = 3) {}

// variadic

func sayStrings(arrayOfStrings:String ...) {
    for s in arrayOfStrings { println(s) }
}

// ignored

func say(s:String, #times:Int, loudly _:Bool) {Dog().say(s, times:times)}

func say2(s:String, #times:Int, _:Bool) {Dog().say(s, times:times)}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let d = Dog()
        d.say("woof") // same as saying d.say("woof", times:1)
        d.say("woof", times:3)

        doThing(b:5, a:10) // legal but don't

        sayStrings("hey", "ho", "nonny nonny no")

        say("hi", times:3, loudly:true)
        
        say2("hi", times:3, true)

    }


}

