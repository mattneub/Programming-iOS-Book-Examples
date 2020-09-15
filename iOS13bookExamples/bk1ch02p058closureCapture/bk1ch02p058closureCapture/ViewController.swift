
import UIKit

// the rule for @escaping is about a function passed in and then passed out
// so, this is legal:

func funcCaller(f:() -> ()) {
    f()
}

// and this is legal

func funcMaker() -> () -> () {
    return { print("hello world") }
}

// but this is not legal, without @escaping

func funcPasser(f:@escaping () -> ()) -> () -> () {
    return f
}
//func funcPasser2(f:() -> ()) -> () -> () {
//    return f
//}

class MyClass {
    var name = "matt"
    func test() {
        func f() {
            print(name) // no self
        }
        let f2 = funcPasser(f:f)
        f2()
    }
}
class MyClass2 {
    var name = "matt"
    func f() {
        print(name) // no self
    }
    func test() {
        let f2 = funcPasser(f:f)
        f2()
    }
}



class ViewController: UIViewController {
    
    func test() {
        func f() {
            print(presentingViewController as Any)
        }
        funcCaller(f:f) // okay
        let f2 = funcPasser(f:f) // okay, even though f doesn't say "self"
        // I regard that as a bug (and I think so does Jordan Rose)
        let f3 = funcPasser {
            print(self.presentingViewController as Any) // self required
        }
        
        let _ = (f2,f3)
    }
    
    func pass100 (_ f:(Int)->()) {
        f(100)
    }
    
    func countAdder(_ f: @escaping ()->()) -> () -> () {
        var ct = 0
        return {
            ct = ct + 1
            print("count is \(ct)")
            f()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var x = 0
        print(x)
        func setX(newX:Int) {
            x = newX
        }
        pass100(setX)
        print(x)

        
        
        func greet () {
            print("howdy")
        }
        let countedGreet = countAdder(greet)
        countedGreet() // 1
        countedGreet() // 2
        countedGreet() // 3

        do {
            let countedGreet = countAdder(greet)
            let countedGreet2 = countAdder(greet)
            countedGreet() // count is 1
            countedGreet2() // count is 1
        }
        
        do { // showing that functions are reference types
            let countedGreet = countAdder(greet)
            let countedGreet2 = countedGreet
            countedGreet() // count is 1
            countedGreet2() // count is 2
        }
        
        
    }



}

