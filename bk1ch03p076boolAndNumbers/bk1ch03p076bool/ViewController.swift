

import UIKit

class ViewController: UIViewController {
    
    var selected : Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.traitCollection.horizontalSizeClass == .Compact {}
    
        let comp = self.traitCollection.horizontalSizeClass == .Compact
        if comp {}
        
        let what = 0x10
        _ = what
        
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
        let ti = NSTimeInterval(2.0)
        _ = cdub
        _ = ti
        
        do {
            if let mars = UIImage(named:"Mars") {
                let marsCG = mars.CGImage
                let szCG = CGSizeMake(
                    // CGImageGetWidth(marsCG),
                    // CGImageGetHeight(marsCG)
                    CGFloat(CGImageGetWidth(marsCG)),
                    CGFloat(CGImageGetHeight(marsCG))
                )
                _ = szCG
            }
        }
        
        do {
            let s = UISlider()
            let g = UIGestureRecognizer()
            
            let pt = g.locationInView(s)
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
            // let j = i + 12/2 // crash
            let (j, over) = Int.addWithOverflow(i,12/2)
            print(j)
            print(over)
        }
        
        do {
            let i = -7
            let j = 6
            print(abs(i)) // 7
            print(max(i,j)) // 6
        }
        
        do {
            let sq = sqrt(2.0)
            print(sq)
            let n = 10
            let i = Int(arc4random())%n
            print(i)
        }


        
    }
    

}

// This API has now been fixed!

extension ViewController {
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}

// This material has been moved to chapter 4!

extension ViewController {
    func test () {
        // how to make a bitmask
        let opts : UIViewAnimationOptions = [.Autoreverse, .Repeat]
        
        _ = opts
    }
}

class MyTableViewCell : UITableViewCell {
    // how to test a bit in a bitmask
    override func didTransitionToState(state: UITableViewCellStateMask) {
        if state.contains(.ShowingEditControlMask) {
            // ... the ShowingEditControlMask bit is set ...
        }
    }

}

