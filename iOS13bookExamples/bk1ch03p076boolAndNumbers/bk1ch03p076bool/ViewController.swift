

import UIKit

class ViewController: UIViewController {
    
    var selected : Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
                
        if self.traitCollection.horizontalSizeClass == .compact {}
    
        let comp = self.traitCollection.horizontalSizeClass == .compact
        if comp {}
        
        let what = 0x10
        print(what)
        _ = what
        
        do {
            // only "true" and "false" can be coerced from String to Bool
            let b = false
            let s = String(b)
            print(b)
            // proving it's not just literals
            let b2 = Bool(s)
            print(b2 as Any)
            print(Bool("FALSE") as Any)
            print(Bool("true") as Any)
            print(Bool("howdy") as Any)
            // this is an oddity, works only with literal
            let b3 = Bool.init(0)
            print(b3)
            // that's because we are actually passing through NSNumber
            let i = 1
            let b4 = Bool(i as NSNumber)
            print(b4)
        }
        
        do {
            let v = UIView()
            v.isUserInteractionEnabled = !v.isUserInteractionEnabled
            v.isUserInteractionEnabled.toggle() // new in Swift 4.2
        }
        
        do {
            print(Int.max)
            print(pow(2,63)-1)
            print(Int.min)
            print(0-pow(2,63))
        }
        
        do {
            let i : CLong = 1
            _ = i
            let d : TimeInterval = 1
            _ = d
        }
        
        do {
            print(Int8.max)
            // let i : Int8 = 128
            let i : Int16 = 128
            // let _ = Int8(i) // crash
            let ii = Int8(exactly:i)
            print(ii as Any)
            _ = ii
        }
        
        do {
            let i : Int16 = 128
            let ii = Int8(clamping:i)
            print(ii)
            _ = ii
        }
        
        do {
            let i : Int16 = 128 // 0b10000000
            print(i)
            print(Int16(0b10000000))
            let ii = Int8(truncatingIfNeeded:i) // -128
            print(ii)
            print(Int8(~0b1111111))
            print(Int8(bitPattern: 0b10000000)) // how to write a 2s complement binary number
            print(Int8.min)
            _ = ii
        }
        
        do {
            let i : Int16 = 128
//            let ii : Int8 = numericCast(i)
//            print(ii)
//            _ = ii
            _ = i
        }
        
        do {
            let ii = Int8(127.9)
            print(ii)
            _ = ii
        }
        
        if Int(3e2) == 300 {
            print("yep")
        }

        if Double(0x10p2) == 64 {
            print("yep")
        }
        
        // let d : Double = .64 // illegal in Swift
        
        // coercion
        
        let i = 10
        let x = Double(i)
        print(x) // 10.0, a Double
        let y = 3.8
        let j = Int(y)
        print(j) // 3, an Int
        
        // no implicit coercion for variables
        
        do {
            let d : Double = 10
            // let d2 : Double = i // compile error; you need to say Double(i)

            let n = 3.0
            let nn = 10/3.0
            // let x2 = i / n // compile error; you need to say Double(i)
            
            _ = d
            _ = n
            _ = nn
        }
        
        let cdub = CDouble(1.2)
        let ti = TimeInterval(2.0)
        _ = cdub
        _ = ti
        
        do {
            if let mars = UIImage(named:"Mars") {
                let marsCG = mars.cgImage!
                let szCG = CGSize(
                    // CGImageGetWidth(marsCG),
                    // CGImageGetHeight(marsCG)
                    // legal because there is an Int initializer
                    width:marsCG.width,
                    height:marsCG.height
                )
                _ = szCG
            }
        }
        
        do {
            let s = UISlider()
            let g = UIGestureRecognizer()
            
            let pt = g.location(in:s)
            let percentage = pt.x / s.bounds.size.width
            // let delta = percentage * (s.maximumValue - s.minimumValue) // compile error
            let delta = Float(percentage) * (s.maximumValue - s.minimumValue)

            _ = delta
        }
        
        do {
            var i = UInt8(1)
            let j = Int8(2)
            i = numericCast(j)
            _ = i
        }
        
        do {
            let i = Int.max - 2
            do {
//                let j = i + 12/2 // crash
                let j = i &+ 12/2
                print(j)
                _ = j
            }
            let (j, over) = i.addingReportingOverflow(12/2) // NB now an instance method
            print(j)
            print(over)
        }
        
        do {
            for i in 1...5 {
                if i % 2 == 0 {
                    print(i, "is even")
                }
                if i.isMultiple(of: 2) { // new in Swift 5
                    print(i, "is even")
                }
                print(i.quotientAndRemainder(dividingBy: 2))
            }
        }
        
        do {
            let d = 6.4
            let r = d.remainder(dividingBy: 3)
            print(r)
        }
        
        do {
            let i = -7
            let j = 6
            print(abs(i)) // 7
            print(max(i,j)) // 6
            
        }
        
        do {
//            let sq = sqrt(2.0)
//            print(sq)
//            let n = 10
//            let i = Int(arc4random())%n
//            print(i)
            
            print(2.squareRoot()) // legal because Swift coerces to Double
            let two = 2
            // print(two.squareRoot())
            print(Double(two).squareRoot())
            print(2.0.squareRoot())
            
            let ran = Int.random(in: 1...10)
            print("random:", ran)
            
            let x = sin(2.0)
            _ = x
        }
        
        do {
            let d = 2.0
            let dd = 2.1
            print(Double.maximum(d, dd))
            //print(Double.abs(d))
            print(d.squareRoot())
            print(dd.rounded())
            
        }
        
        do {
            let d1 = 0.33333333333333
            let d2 = 1.0/3.0
            print(Int(abs(d1-d2) / Double.ulpOfOne))
            
            print(d1)
            print(d2)
            print(d1 == d2)
            
            let eq = d1 >= d2.nextDown && d1 <= d2.nextUp
            print(eq)
            
            let f = 0.1
            var sum = 0.0
            for _ in 0..<10 { sum += f }
            let product = f * 10
            print(sum, product)
            print(sum == product)
            let eq2 = sum >= product.nextDown && sum <= product.nextUp
            print(eq2)
            
            let r1 = sum * 10000
            let r2 = product * 10000
            print(r1, r2)
            let eq3 = r1 >= r2.nextDown && r1 <= r2.nextUp
            print(eq3)


        }


        
    }
    

}

// This API has now been fixed!

extension ViewController {
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

// This material has been moved to chapter 4!

extension ViewController {
    func test () {
        // how to make a bitmask
        let opts : UIView.AnimationOptions = [.autoreverse, .repeat]
        
        _ = opts
    }
}

class MyTableViewCell : UITableViewCell {
    // how to test a bit in a bitmask
    override func didTransition(to state: UITableViewCell.StateMask) {
        if state.contains(.showingEditControl) {
            // ... the ShowingEditControl bit is set ...
        }
    }

}

