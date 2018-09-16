

import UIKit

struct Digit {
    var number : Int
    init(_ n:Int) {
        self.number = n
    }
    subscript(ix:Int) -> Int {
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
    struct Noise {
        static var noise = "woof"
    }
    func bark() {
        print(Dog.Noise.noise)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var d = Digit(1234)
        let aDigit = d[1] // 2
        print(aDigit)
        
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
        let window = app.keyWindow
        let vc = window?.rootViewController
        print(vc as Any)
        
        let vc2 = UIApplication.shared.keyWindow?.rootViewController
        print(vc2 as Any)


    }


}

