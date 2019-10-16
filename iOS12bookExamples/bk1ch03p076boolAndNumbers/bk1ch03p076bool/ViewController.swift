

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
            // let ii = Int8(i)
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
        
        if 3e2 == 300 {
            print("yep")
        }

        if 0x10p2 == 64 {
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
            let d1 = 0.3333333333333
            let d2 = 1.0/3.0
            print(Int(abs(d1-d2) / Double.ulpOfOne))
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

