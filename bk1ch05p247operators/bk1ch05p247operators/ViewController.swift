
import UIKit
import Swift

struct Vial {
    var numberOfBacteria : Int
    init(_ n:Int) {
        self.numberOfBacteria = n
    }
}
extension Vial : Equatable {
    static func +(lhs:Vial, rhs:Vial) -> Vial {
        let total = lhs.numberOfBacteria + rhs.numberOfBacteria
        return Vial(total)
    }
    static func +=(lhs: inout Vial, rhs:Vial) {
        let total = lhs.numberOfBacteria + rhs.numberOfBacteria
        lhs.numberOfBacteria = total
    }

    static func ==(lhs:Vial, rhs:Vial) -> Bool {
        return lhs.numberOfBacteria == rhs.numberOfBacteria
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
    -> ReversedRandomAccessCollection<CountableRange<Bound>>
    where Bound : Comparable & Strideable { // NB! Integer conformance no longer needed
        // in fact, Integer no longer exists
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
        let ix = arr.index(of:v1) // Optional wrapping 0
        print(ix as Any)

        print(2^^2) // 4
        print(2^^3) // 8
        print(3^^3) // 27

        
//        let r1 = 1<<<10
        let r2 = 10>>>1
//        for i in r1 {print(i)}
        for i in r2 {print(i)}
    
    }



}

