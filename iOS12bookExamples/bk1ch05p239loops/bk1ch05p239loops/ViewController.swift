

import UIKit

enum MyError {
    case number(Int)
    case message(String)
    case fatal
}

struct Primes {
    static var primes = [2]
    static func appendNextPrime() {
        next: for i in (primes.last!+1)... {
            let sqrt = Int(Double(i).squareRoot())
            for factor in primes.lazy.prefix(while:{$0 <= sqrt}) {
                if i % factor == 0 {
                    continue next
                }
            }
            primes.append(i)
            print("appended a prime")
            return
        }
    }
    static func nthPrime(_ n:Int) -> Int {
        print("I was asked for prime", n)
        while primes.count < n {
            appendNextPrime()
        }
        return primes[n-1]
    }
}

class ViewController: UIViewController {
    
    var movenda = [1,2,3]
    var movenda2 = [1,2,3]
    
    var boardView = UIView()
    
    var tiles : [UIView] = []
    var centers : [CGPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            while self.movenda.count > 0 {
                let p = self.movenda.removeLast()
                // ...
                print(p)
            }
        }
        
        do {
            while let p = self.movenda2.popLast() {
                print(p)
            }
        }
        
        do {
            let tvc = UITableViewCell()
            let subview1 = UIView()
            let subview2 = UITextField()
            tvc.addSubview(subview1)
            subview1.addSubview(subview2)
            let textField = subview2
            
            var v : UIView = textField
            repeat { v = v.superview! } while !(v is UITableViewCell)
            if let c = v as? UITableViewCell {
                print("got it \(c)")
            } else {
                print("nope")
            }
        }
        
        do {
            let tvc = UITableViewCell()
            let subview1 = UIView()
            let subview2 = UITextField()
            tvc.addSubview(subview1)
            subview1.addSubview(subview2)
            let textField = subview2
            var v : UIView = textField
            // v = tvc // try this to prove that we can cycle up to the top safely
            while let vv = v.superview, !(vv is UITableViewCell) {v = vv}
            if let c = v.superview as? UITableViewCell {
                print("got it \(c)")
            } else {
                print("nope, but at least we didn't crash")
            }
        }
        
        do {
            let tvc = UITableViewCell()
            let subview1 = UIView()
            let subview2 = UITextField()
            tvc.addSubview(subview1)
            subview1.addSubview(subview2)
            let textField = subview2
            var v : UIView? = textField
            repeat {v = v?.superview} while !(v is UITableViewCell || v == nil)
            if let c = v as? UITableViewCell {
                print("got it \(c)")
            } else {
                print("nope")
            }
        }
        
        do {
            let arr : [MyError] = [
                .message("ouch"), .message("yipes"), .number(10),
                .number(-1), .fatal
            ]
            var i = 0
            // removed use of i++, deprecated in Swift 2.2, to be removed in Swift 3
            while case let .message(message) = arr[i]  {
                print(message)
                i += 1
            }
            print(arr)

        }
        
        // this _entire_ construct is deprecated in Swift 2.2, to be removed in Swift 3
        /*
        do {
            for var i = 1; i < 6; i++ {
                print(i)
            }
        }
 */
        
        do {
            for i in 1...5 {
                print(i)
            }
        }
        
        do {
            for var i in 1...5 { // for var still legal
                // removed use of i++, deprecated in Swift 2.2, to be removed in Swift 3
                i = i + 1
                print(i)
            }
        }
        

        do {
            var g = (1...5).makeIterator()
            while let i = g.next() {
                print(i)
            }
        }
        
        do {
            for c in "howdy" {
                print(c)
            }
        }
        
        do {
            for v in self.boardView.subviews {
                v.removeFromSuperview()
            }
        }
        
        do {
            let p = Pep()
            for boy in p.boys() as! [String] { // boys() doesn't provide type info
                let s = "One pep boy is " + boy
                print(s)
            }
        }
        
        do {
            for (i,v) in self.tiles.enumerated() {
                v.center = self.centers[i]
            }
        }
        
        do {
            for case let b as UIButton in self.boardView.subviews {
                b.isHidden = true
            }
        }
        
        do {
            for i in 0...10 where i % 2 == 0 { // new in Swift 2.0
                print(i)
            }
        }
        
        do {
            for i in stride(from:10, through: 0, by: -2) {
                print(i) // 10, 8, 6, 4, 2, 0
            }
        }
        
        do {
            let range = (0...10).reversed().filter{$0 % 2 == 0}
            for i in range {
                print(i) // 10, 8, 6, 4, 2, 0
            }
        }
        
        // new in Swift 3 is "sequence"; it generates the next based on the current
        // it is lazy and theoretically infinite...
        // so either take a prefix or return nil to stop it
        
        do {
            let seq = sequence(first:1) {$0 >= 10 ? nil : $0 + 1}
            for i in seq {
                print(i) // 1,2,3,4,5,6,7,8,9,10
            }
            let seq2 = sequence(first:1) {$0 + 1}
            for i in seq2.prefix(5) {
                print(i) // 1,2,3,4,5
            }
        }
        
        do {
            // form 1
            let directions = sequence(first:1) {$0 * -1}
            print(Array(directions.prefix(10)))
            // [1, -1, 1, -1, 1, -1, 1, -1, 1, -1]
            // i.e. first 10 elements of an infinite series alternating between 1 and -1
            
            // form 2; the state is an inout param to the function
            // in this example we use it as a scratchpad to maintain the most recent pair
            let fib = sequence(state:(0,1)) {
                (pair: inout (Int,Int)) -> Int in
                let n = pair.0 + pair.1
                pair = (pair.1,n)
                return n
            }
            for i in fib.prefix(10) {
                print(i)
            }
            // i.e. the first 10 elements of the fibonacci sequence
        }
        
        
        do {
            let arr1 = ["CA", "MD", "NY", "AZ"]
            let arr2 = ["California", "Maryland", "New York"]
            var d = [String:String]()
            for (s1,s2) in zip(arr1,arr2) {
                d[s1] = s2
            } // now d is ["MD": "Maryland", "NY": "New York", "CA": "California"]
            print(d)
        }
        
        do {
            let arr : [MyError] = [
                .message("ouch"), .message("yipes"), .number(10),
                .number(-1), .fatal
            ]
            for case let .number(i) in arr {
                print(i) // 10, -1
            }
        }
        
        do {
            let arr : [Any] = ["hey", 1, "ho"]
            for case let s as String in arr {
                print(s)
            }
        }

        
        
        // this is my one example where the loss of C-style for loops is really a pity
        // it was great being able to do two things in the prep line
        /*
        do {
            var values = [0.0]
            for (var i = 20, direction = 1.0; i < 60; i += 5, direction *= -1) {
                values.append(direction * M_PI / Double(i))
            }
            print(values) // [0.0, 0.15707963267948966, -0.12566370614359174, 0.10471975511965977, -0.089759790102565518, 0.078539816339744828, -0.069813170079773182, 0.062831853071795868, -0.057119866428905326]
        }
        */
        
        // here's one workaround
        do {
            var values = [0.0]
            var direction = 1.0
            for i in stride(from: 20, to: 60, by: 5) {
                values.append(direction * .pi / Double(i))
                direction *= -1
            }
            print(values)
        }
        
        // this is Swiftier and tighter, but a lot harder to understand
        do {
            var values = [0.0]
            for (ix,i) in stride(from: 20, to: 60, by: 5).enumerated() {
                values.append((ix % 2 == 1 ? -1.0 : 1.0) * .pi / Double(i))
            }
            print(values)
        }
        
        // perhaps this is clearest
        // we can use sequence to generate the alternating positive-negative
        // NOTE change in Swift 4 to tuple!
        // (however, the example is no longer in the book)
        do {
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            let values = zip(bases, directions).map {Double($0.1) * .pi / Double($0.0)} // *
            print(values) // same as previous but without the initial 0.0
        }
        
        do {
            for i in 1...5 {
                for j in 1...5 {
                    print("\(i), \(j);")
                    break
                }
            }
            
            outer: for i in 1...5 {
                for j in 1...5 {
                    print("\(i), \(j);")
                    break outer
                }
            }
        }
        
        do {
            _ = Primes.nthPrime(5)
            _ = Primes.nthPrime(3) // no new primes generated
            _ = Primes.nthPrime(7) //
        }
        
        do { // new in 2.0, you can break to an "if" or "do"
            test: if true {
                for i in 1...5 {
                    for j in 1...5 {
                        print("\(i), \(j);")
                        break test
                    }
                }
            }
        }
                
        test2: do { // new in 2.0, you can break from within an "if", but only a label break
            var ok : Bool { return true }
            if ok {
                print("step one")
                break test2
            }
            print("step two")
        }
        
        
    }



}

