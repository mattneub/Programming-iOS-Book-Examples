

import UIKit

// not in the book, but a nice example of what can constitute a type

class IntAdder {
    var array : [Int] // property
    init(_ array : [Int]) { // initializer
        self.array = array
    }
    func sum() -> Int { // method
        return self.array.reduce(0,+)
    }
    enum MyError { // nested type
        case outOfBounds
    }
    subscript(ix:Int) -> (Int?, MyError?) { // subscript
        if self.array.indices.contains(ix) {
            return (self.array[ix], nil)
        }
        return (nil, .outOfBounds)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myAdder = IntAdder([1,2,3,4]) // initializer call
        let intAndErr = myAdder[10] // subscript call
        print(intAndErr) // use nested type
        let result = myAdder.sum() // method call
        print(result)
        myAdder.array = [2,4,6,8] // property access
        let result2 = myAdder.sum() // method call
        print(result2)
        
        
    }


}


