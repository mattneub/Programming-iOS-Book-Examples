
import UIKit
import Swift

struct Vial : Equatable {
    var numberOfBacteria : Int
    init(_ n:Int) {
        self.numberOfBacteria = n
    }
}
// New in Swift 4.1, just declaring conformance to Equatable (_not_ in an extension)
// is sufficient to generate exactly the implementation of `==` that we want!
/*
extension Vial : Equatable {
    static func ==(lhs:Vial, rhs:Vial) -> Bool {
        return lhs.numberOfBacteria == rhs.numberOfBacteria
    }
}
 */
extension Vial {
    static func +(lhs:Vial, rhs:Vial) -> Vial {
        let total = lhs.numberOfBacteria + rhs.numberOfBacteria
        return Vial(total)
    }
    static func +=(lhs: inout Vial, rhs:Vial) {
        let total = lhs.numberOfBacteria + rhs.numberOfBacteria
        lhs.numberOfBacteria = total
    }
}

infix operator ^^
extension Int {
    static func ^^(lhs:Int, rhs:Int) -> Int {
        var result = lhs
        for _ in 1..<rhs {result *= lhs}
        return result
    }
}

infix operator >>> : RangeFormationPrecedence
func >>><Bound>(maximum: Bound, minimum: Bound)
    -> ReversedCollection<Range<Bound>>
    where Bound : Strideable {
        return (minimum..<maximum).reversed()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var v1 = Vial(500_000)
        let v2 = Vial(400_000)
        let v3 = v1 + v2
        print(v3.numberOfBacteria) // 900000
    
        v1 += v2
        print(v1.numberOfBacteria) // 900000
        
        let ok = v1 == v3
        print(ok)
        
        let arr = [v1,v2]
        let ix = arr.firstIndex(of:v1) // Optional wrapping 0
        print(ix as Any)

        print(2^^2) // 4
        print(2^^3) // 8
        print(3^^3) // 27

        
//        let r1 = 1<<<10
        let r2 = 10>>>1
//        for i in r1 {print(i)}
        for i in r2 {print(i)}
        
        // showing that the same injection works for enums
        // this solves the problem where (without Equatable)
        // an enum with associated values can't be compared at all
        enum MyError : Equatable {
            case number(Int)
            case message(String)
            case fatal
        }
        do {
            let err1 = MyError.number(1)
            let err2 = MyError.number(1)
            if err1 == err2 {
                print("yep")
            }
        }
        
        do {
            let err1 = MyError.fatal
            let err2 = MyError.fatal
            if err1 == err2 {
                print("yep")
            }
        }



    
    }

}

