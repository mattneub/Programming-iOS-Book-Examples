
import UIKit

@objc protocol Flier {
    optional var song : String {get}
    optional var song2 : String {get set}
    optional func sing()
    optional func sing2() -> String
}
class Bird : Flier {
    @objc func sing() {
        print("tweet")
    }
    @objc func sing2() -> String {
        return "warble"
    }
    @objc var song2 : String = "gobble gobble"
}

class Insect : Flier {
    
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
    print("this nest contains \(nest.eggCount) eggs")
}

class ViewController: UIViewController {
    
    init() {
        super.init(nibName: "ViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder:aDecoder)
    }
    
    
    // inappropriate here, but a legal alternative:
    
//    required convenience init(coder aDecoder: NSCoder) {
//        self.init()
//    }



    override func viewDidLoad() {
        super.viewDidLoad()

        let f : Flier = Bird()
        let s = f.song // s is an Optional wrapping a String
        print(s)
        f.sing?()
        let s2 = f.sing2?()
        print(s2)

//        var f2 : Flier = Bird()
//        f2.song2 = "woof" // compile error
        
        do {
            let i : Flier = Insect()
            let s = i.song
            print(s) // nil
            i.sing?() // safe but nothing happens
            let s2 = i.sing2?() // nil
            print(s2)
            
            // i.sing!() // legal but we will crash
        }
        
        
        
        reportEggs(4) // this nest contains 4 eggs

    
    }
    
    func f(f:protocol<CustomStringConvertible, CustomDebugStringConvertible>) {} // just showing the notation



}

