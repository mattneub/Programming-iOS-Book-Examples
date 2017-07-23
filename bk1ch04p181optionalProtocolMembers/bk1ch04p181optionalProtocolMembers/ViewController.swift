
import UIKit

@objc protocol Flier {
    @objc optional var song : String {get}
    @objc optional var song2 : String {get set}
    @objc optional var song3 : String? {get}
    @objc optional func sing()
    @objc optional func sing2() -> String
}
// NB no longer necessary to repeat `@objc` in the Bird declaration
class Bird : Flier {
    func sing() {
        print("tweet")
    }
    func sing2() -> String {
        return "warble"
    }
    // var song3 : String? = "ooga ooga"
    var song2 : String = "gobble gobble"
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

struct Nest : ExpressibleByIntegerLiteral {
    var eggCount : Int = 0
    init() {}
    init(integerLiteral val: Int) {
        self.eggCount = val
    }
    init?(_ s:String) {
        if let i = Int(s) {
            self.eggCount = i
        } else {
            return nil
        }
    }
}

func reportEggs(_ nest:Nest) {
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
        print(s as Any)
        let sss = f.song3 // sss is an Optional wrapping an Optional wrapping a String
        print(sss as Any)
        f.sing?()
        let s2 = f.sing2?()
        print(s2 as Any)

//        var f2 : Flier = Bird()
//        f2.song2 = "woof" // compile error
        
        do {
            let i : Flier = Insect()
            let s = i.song
            print(s as Any) // nil
            i.sing?() // safe but nothing happens
            let s2 = i.sing2?() // nil
            print(s2 as Any)
            
            // i.sing!() // legal but we will crash
        }
        
        
        
        reportEggs(4) // this nest contains 4 eggs
        if let n = Nest("4") {
            reportEggs(n)
        }

    
    }
    



}

