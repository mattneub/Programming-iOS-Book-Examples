
import UIKit

struct Vial {
    var numberOfBacteria : Int
    init(_ n:Int) {
        self.numberOfBacteria = n
    }
}
func +(lhs:Vial, rhs:Vial) -> Vial {
    let total = lhs.numberOfBacteria + rhs.numberOfBacteria
    return Vial(total)
}
func +=(inout lhs:Vial, rhs:Vial) {
    let total = lhs.numberOfBacteria + rhs.numberOfBacteria
    lhs.numberOfBacteria = total
}

func ==(lhs:Vial, rhs:Vial) -> Bool {
    return lhs.numberOfBacteria == rhs.numberOfBacteria
}
extension Vial:Equatable{}

infix operator ^^ {
}
func ^^(lhs:Int, rhs:Int) -> Int {
    var result = lhs
    for _ in 1..<rhs {result *= lhs}
    return result
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var v1 = Vial(500_000)
        let v2 = Vial(400_000)
        let v3 = v1 + v2
        println(v3.numberOfBacteria) // 900000
    
        v1 += v2
        println(v1.numberOfBacteria) // 900000
        
        let ok = v1 == v3
        println(ok)
        
        let arr = [v1,v2]
        let ix = find(arr,v1) // Optional wrapping 0
        println(ix)

        println(2^^2) // 4
        println(2^^3) // 8
        println(3^^3) // 27

    
    }



}

