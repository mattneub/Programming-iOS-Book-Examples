

import UIKit

enum Pep : String, CaseIterable {
    case manny
    case moe
    case jack
    static subscript(_ ix: Int) -> String {
        Self.allCases[ix].rawValue.capitalized
    }
}

struct Digit {
    var number : Int
    init(_ n:Int) {
        self.number = n
    }
    subscript(ix:Int = 0) -> Int {
        get {
            let s = String(self.number)
            return Int(String(s[s.index(s.startIndex, offsetBy:ix)]))!
        }
        set {
            var s = String(self.number)
            let i = s.index(s.startIndex, offsetBy:ix)
            s.replaceSubrange(i...i, with: String(newValue))
            self.number = Int(s)!
        }
    }
}

class Dog {
    static let sound = "arf"
    struct Noise {
        static var noise = "woof"
        // func barkTheDog() { bark() }
        func barkTheDog() { print(sound) } // ok, with no target
        static var othernoise = sound
        var otherothernoise = sound
    }
    func bark() {
        print(Dog.Noise.noise)
        // print(sound)
    }
}

class Foo {
    class var v : String {return "howdy"}
    class func g() {}
    class Bar {
        var vv = v
        var gg = g // compile error? no, not any more
        func f() {
            print(v) // ok
            g() // compile error? no, not any more
        }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var d = Digit(1234)
        let aDigit = d[1] // 2
        print(aDigit)
        
        let anotherDigit = d[]
        print(anotherDigit)
        
        d[0] = 2 // now d.number is 2234
        print(d.number)
        
        struct What {
            subscript(first:Int, second:Int) -> Int {
                return 0
            }
        }
        let w = What()
        print(w[1,2]) // compiles; there are still too dang-blasted many externalization rules

        Dog.Noise.noise = "arf"
        Dog().bark()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let app = UIApplication.shared
        let window = app.windows.first
        let vc = window?.rootViewController
        print(vc as Any)
        
        let vc2 = UIApplication.shared.windows.first?.rootViewController
        print(vc2 as Any)
        
        // might all fall to the ground due to deprecation? I need another example?
        print(app.connectedScenes.count)
        let scene = app.connectedScenes.first as? UIWindowScene
        let wind = scene?.windows.first
        // let wind2 = scene?.keyWindow // will they always be the same?
        let root = wind?.rootViewController
        print(root as Any)
        
        let secondPepBoy = Pep[1] // Moe
        print(secondPepBoy)

    }
    
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


extension UIViewController : UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ tf:UITextField) {
        let app = UIApplication.shared
        delay(2) {
            print(app) // give ourselves a place to stand when the keyboard is showing
        }
    }
}


