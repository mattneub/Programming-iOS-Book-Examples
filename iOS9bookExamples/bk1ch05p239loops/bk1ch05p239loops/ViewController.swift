

import UIKit

enum Error {
    case Number(Int)
    case Message(String)
    case Fatal
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
            while let vv = v.superview where !(vv is UITableViewCell) {v = vv}
            if let c = v.superview as? UITableViewCell {
                print("got it \(c)")
            } else {
                print("nope, but at least we didn't crash")
            }
        }
        
        do {
            let arr : [Error] = [
                .Message("ouch"), .Message("yipes"), .Number(10),
                .Number(-1), .Fatal
            ]
            var i = 0
            // removed use of i++, deprecated in Swift 2.2, to be removed in Swift 3
            while case let .Message(message) = arr[i]  {
                i = i.successor()
                print(message)
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
            for var i in 1...5 {
                // removed use of i++, deprecated in Swift 2.2, to be removed in Swift 3
                i = i + 1
                print(i)
            }
        }
        

        do {
            var g = (1...5).generate()
            while let i = g.next() {
                print(i)
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
            for (i,v) in self.tiles.enumerate() {
                v.center = self.centers[i]
            }
        }
        
        do {
            for i in 0...10 where i % 2 == 0 { // new in Swift 2.0
                print(i)
            }
        }
        
        do {
            for i in 10.stride(through: 0, by: -2) {
                print(i) // 10, 8, 6, 4, 2, 0
            }
        }
        
        do {
            let range = (0...10).reverse().filter{$0 % 2 == 0}
            for i in range {
                print(i) // 10, 8, 6, 4, 2, 0
            }
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
            let arr : [Error] = [
                .Message("ouch"), .Message("yipes"), .Number(10),
                .Number(-1), .Fatal
            ]
            for case let .Number(i) in arr {
                print(i) // 10, -1
            }
        }

        
        // this _entire_ construct is deprecated in Swift 2.2, to be removed in Swift 3
        /*
        do {
            var i : Int
            for i = 1; i < 6; i++ {
                print(i)
            }
        }
        
        do {
            for var i = 1; i < 6; i++ {
                print(i)
            }
        }
 
        do {
            let tvc = UITableViewCell()
            let subview1 = UIView()
            let subview2 = UITextField()
            tvc.addSubview(subview1)
            subview1.addSubview(subview2)
            let textField = subview2

            var v : UIView
            for v = textField; !(v is UITableViewCell); v = v.superview! {}
            print(v)
        }
        */
        
        // this is my one example where the loss of C-style for loops is really a pity
        // it was great being able to do two things in the prep line
        /*
        do {
            var values = [0.0]
            for (var i = 20, direction = 1.0; i < 60; i += 5, direction *= -1) {
                values.append( direction * M_PI / Double(i) )
            }
            print(values) // [0.0, 0.15707963267948966, -0.12566370614359174, 0.10471975511965977, -0.089759790102565518, 0.078539816339744828, -0.069813170079773182, 0.062831853071795868, -0.057119866428905326]
        }
        */
        
        // here's one workaround
        do {
            var values = [0.0]
            var direction = 1.0
            for i in 20.stride(to: 60, by: 5) {
                values.append( direction * M_PI / Double(i) )
                direction *= -1
            }
            print(values)
        }
        
        // this is Swiftier and tighter, but a lot harder to understand
        do {
            var values = [0.0]
            for (ix,i) in 20.stride(to: 60, by: 5).enumerate() {
                values.append( (ix % 2 == 1 ? -1.0 : 1.0) * M_PI / Double(i) )
            }
            print(values)
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

