
import UIKit

func repeatString(s:String, #times:Int) -> String {
    var result = ""
    for _ in 1...times { result += s }
    return result
}

func repeatString2(s:String, times n:Int) -> String {
    var result = ""
    for _ in 1...n { result += s}
    return result
}

class Dog {
    func say(s:String, times:Int) {
        for _ in 1...times {
            println(s)
        }
    }
    func say2(s:String, _ times:Int) {
        for _ in 1...times {
            println(s)
        }
    }
}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = repeatString("hi", times:3)
        println(s)
        
        let s2 = repeatString2("hi", times:3)
        println(s2)
        
        let d = Dog()
        d.say("woof", times:3)

        let d2 = Dog()
        d.say2("woof", 3)

        
    }



}

