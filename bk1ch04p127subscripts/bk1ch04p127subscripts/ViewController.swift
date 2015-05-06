

import UIKit

struct Digit {
    var number : Int
    init(_ n:Int) {
        self.number = n
    }
    subscript(ix:Int) -> Int {
        get {
            let s = String(self.number)
            return String(Array(s)[ix]).toInt()!
        }
        set {
            var arr = Array(String(self.number))
            arr[ix] = Character(String(newValue))
            self.number = String(arr).toInt()!
        }
    }
}

class Dog {
    struct Noise {
        static var noise = "Woof"
    }
    func bark() {
        println(Dog.Noise.noise)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var d = Digit(1234)
        let aDigit = d[1] // 2
        println(aDigit)
        
        d[0] = 2 // now d.number is 2234
        println(d.number)

        Dog.Noise.noise = "Arf"
        Dog().bark()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let app = UIApplication.sharedApplication()
        let window = app.keyWindow
        let vc = window?.rootViewController
        println(vc)
        
        let vc2 = UIApplication.sharedApplication().keyWindow?.rootViewController
        println(vc2)


    }


}

