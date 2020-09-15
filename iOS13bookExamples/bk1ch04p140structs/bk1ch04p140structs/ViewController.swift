

import UIKit

struct Digit {
    var number = 42
}
struct Digit2 {
    var number = 42
    init(number:Int) {
        self.number = number
    }
}
struct Digit3 {
    var number = 42
    init() {}
    init(number:Int) {
        self.number = number
    }
}
struct Digit3b {
    var number = 42
    init() {}
}
struct Digit4 {
    var number : Int
}
struct Digit5 {
    let number : Int
}
struct Digit6 {
    let number = 42
}

struct Test {
    var number = 42
    var name : String
    let age : Int
    let greeting = "Hello"
//    init(name:String, age:Int) {
//        self.name = name; self.age = age
//    }
}

struct S {
    private var _p : Int = 0
    var p : Int {
        get { self._p }
        set { self._p = newValue }
    }
}

struct Thing : RawRepresentable {
    let rawValue : Int
    static let one : Thing = Thing(rawValue:1)
    static let two : Thing = Thing(rawValue:2)
}

struct DigitReplacer {
    var number = 42
    mutating func replace() {
        self = DigitReplacer(number:86)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = Digit()
        let dddd = Digit(number:86)
        
        // let d2a = Digit2() // compile error
        let d2 = Digit2(number:86)
        
        let d3 = Digit3()
        let dd3 = Digit3(number:86)
        
        // let dd3b = Digit3b(number:86) // compile error
        
        let dd = Digit(number:86)
        let d4 = Digit4(number:86)
        
        let d5 = Digit5(number:86)
        // let d6 = Digit6(number:86) // compile error
        
        do {
            let d7 = Test(number: 8, name: "matt", age: 65)
            let d7b = Test(name: "matt", age: 65) // can omit `number:` because it has a value
            _ = (d7, d7b)
        }
        
        var d7 = DigitReplacer()
        print(d7.number)
        d7.replace()
        print(d7.number)
        
        let thing : Thing = .one // no need to say Thing.one here
        print(thing)

        _ = d
        _ = d2
        _ = d3
        _ = d4
        _ = d5
        _ = dd
        _ = dd3
        _ = thing
        _ = dddd
        
    }


}

