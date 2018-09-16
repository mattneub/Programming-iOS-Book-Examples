

import UIKit
import UserNotifications

struct Dog : Hashable {
    let name : String
    let license : Int
    static func ==(lhs:Dog, rhs:Dog) -> Bool {
        return lhs.name == rhs.name
    }
    var hashValue: Int { return name.hashValue }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let set : Set<Int> = [1, 2, 3, 4, 5]
            print(set)
        }
        do {
            let set : Set = [1, 2, 3, 4, 5]
            print(set)
        }

        do {
            let arr = [1,2,1,3,2,4,3,5]
            let set = Set(arr)
            let arr2 = Array(set) // [5,2,3,1,4], perhaps
            print(arr2)
        }
        
        do {
            let set : Set = [1,2,3,4,5]
            let set2 = Set(set.map {$0+1}) // {6, 5, 2, 3, 4}, perhaps
            print(set2)
        }
        
        do {
            let set : Set = [1,2,3,4,5]
            let set2 = set.filter {$0>3}
            print(set2)
        }
        
        do {
            let opts = UIViewAnimationOptions(rawValue:0b00011000)
            _ = opts
        }
        
        do {
            // showing the difference between insert and update
            var set : Set = [Dog(name:"Fido", license:1)]
            let d = Dog(name:"Fido", license:2)
            set.insert(d) // [Dog(name: "Fido", license: 1)]
            print(set)
            set.update(with:d) // [Dog(name: "Fido", license: 2)]
            print(set)
        }
        
        do {
            let val = UIViewAnimationOptions.autoreverse.rawValue | UIViewAnimationOptions.repeat.rawValue
            let opts = UIViewAnimationOptions(rawValue: val)
            print(opts)
        }
        
        do {
            let opts : UIViewAnimationOptions = [UIViewAnimationOptions.autoreverse, UIViewAnimationOptions.repeat]
            print(opts)
        }
        
        do {
            var opts = UIViewAnimationOptions.autoreverse
            opts.insert(.repeat) // compiler no longer complains
            print(opts)
        }
        
        do {
            let opts : UIViewAnimationOptions = [.autoreverse, .repeat]
            print(opts)
        }
        
        do {
            UIView.animate(withDuration:0.4, delay: 0, options: [.autoreverse, .repeat],
                animations: {
                    // ...
                })
        }
        
        do {
            var s = Set<Int>()
            s.insert(1)
            let arr = Array(s) as NSArray
            print(arr)
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first // an Optional wrapping a UITouch
        print(t as Any)
    }
    
    let RECENTS = "recents"
    let PIXCOUNT = 20
    func test() {
        let ud = UserDefaults.standard
        var recents = ud.object(forKey:RECENTS) as? [Int]
        if recents == nil {
            recents = []
        }
        var forbiddenNumbers = Set(recents!)
        let legalNumbers = Set(1...PIXCOUNT).subtracting(forbiddenNumbers)
        let newNumber = Array(legalNumbers)[
            Int(arc4random_uniform(UInt32(legalNumbers.count)))
        ]
        forbiddenNumbers.insert(newNumber)
        ud.set(Array(forbiddenNumbers), forKey:RECENTS)
    }


}

class MyTableViewCell : UITableViewCell {
    override func didTransition(to state: UITableViewCellStateMask) {
        let editing = UITableViewCellStateMask.showingEditControlMask.rawValue
        if state.rawValue & editing != 0 {
            // ... the ShowingEditControlMask bit is set ...
        }
    }
}

class MyTableViewCell2 : UITableViewCell {
    override func didTransition(to state: UITableViewCellStateMask) {
        if state.contains(.showingEditControlMask) {
            // ... the ShowingEditControlMask bit is set ...
        }
    }
}


