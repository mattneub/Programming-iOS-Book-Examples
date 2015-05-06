
import UIKit

@objc protocol Flier {
    optional var song : String {get}
    optional var song2 : String {get set}
    optional func sing()
    optional func sing2() -> String
}
@objc class Bird : Flier {
    func sing() {
        println("tweet")
    }
    func sing2() -> String {
        return "warble"
    }
    var song2 : String = "gobble gobble"
}

protocol Flier2 {
    init()
}
class Bird2 : Flier2 {
    // init() {} // compile error
    required init() {}
}
final class Bird3 : Flier2 {
    init() {}
}

struct Nest : IntegerLiteralConvertible {
    var eggCount : Int = 0
    init() {}
    init(integerLiteral val: Int) {
        self.eggCount = val
    }
}
func reportEggs(nest:Nest) {
    println("this nest contains \(nest.eggCount) eggs")
}


class ViewController: UIViewController {
    
    init() {
        super.init(nibName: "ViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder:aDecoder)
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        let f : Flier = Bird()
        let s = f.song // s is an Optional wrapping a String
        println(s)
        f.sing?()
        let s2 = f.sing2?()
        println(s2)

        // f.song2 = "woof" // compile error
        
        
        reportEggs(4) // this nest contains 4 eggs

    
    }



}

