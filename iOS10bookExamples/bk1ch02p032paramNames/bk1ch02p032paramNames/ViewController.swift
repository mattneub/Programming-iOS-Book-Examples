
import UIKit

func echo(_ s:String, times:Int) -> String {
    var result = ""
    for _ in 1...times { result += s }
    return result
}

func echo2(string s:String, times n:Int) -> String {
    var result = ""
    for _ in 1...n { result += s}
    return result
}

class Dog {
    func say(_ s:String, times:Int) {
        for _ in 1...times {
            print(s)
        }
    }
    func say2(_ s:String, _ times:Int) {
        for _ in 1...times {
            print(s)
        }
    }
}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = echo("hi", times:3)
        print(s)
        
        let s2 = echo2(string: "hi", times:3)
        print(s2)
        
        // let s3 = echo2(times:3, string:"hi") // nope
        
        let d = Dog()
        d.say("woof", times:3)
        
        let d2 = Dog()
        d2.say2("woof", 3)
        
        do {
            let s = "hello"
            let s2 = s.replacingOccurrences(of: "ell", with:"ipp")
            // s2 is now "hippo"
            print(s2)
        }
    }
}

extension Thing {
    func makingHash(of otherThing:Thing) -> Thing {return Thing()}
    // renamified as `makingHashOf:`
    func makingHash(cornedBeef otherThing:Thing) -> Thing {return Thing()}
    // renamified as `makingHashWithCornedBeef:`
    func makingHash(thing otherThing:Thing) -> Thing {return Thing()}
    

}

