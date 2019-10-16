

import UIKit
import UserNotifications

struct Person : Hashable {
    let firstName: String
    let lastName: String
}

// suppose you don't want all members involved in equality / hashability
struct Dog : Hashable {
    let name : String
    let license : Int
    let color : UIColor
    // for equatable, write out == by hand
    static func ==(lhs:Dog,rhs:Dog) -> Bool {
        return lhs.name == rhs.name && lhs.license == rhs.license
    }
    // for hashable, implement hash(into:)
    func hash(into hasher: inout Hasher) {
        name.hash(into:&hasher)
        license.hash(into:&hasher)
    }
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
            let opts = UIView.AnimationOptions(rawValue:0b00011000)
            _ = opts
        }
        
        do {
            let set : Set<Person> = [
                Person(firstName: "Matt", lastName: "Neuburg"),
                Person(firstName: "Groucho", lastName: "Marx")
            ]
            let ok = set.contains(Person(firstName: "Groucho", lastName: "Marx")) // true
            print(ok)
            let h = Person(firstName: "Matt", lastName: "Neuburg").hashValue
            print(h)

        }
        
        do {
            // showing the difference between insert and update
            var set : Set = [Dog(name:"Fido", license:1, color: .green)]
            let d = Dog(name:"Fido", license:1, color: .red)
            set.insert(d) // green dog
            print(set.count)
            print(set)
            set.update(with:d) // red dog
            print(set)
        }
        
        do {
            // accidentally omitted from the book: showing the use of insert result
            // typical usage: unique array in order
            var arr = ["Mannie", "Mannie", "Moe", "Jack", "Jack", "Moe", "Mannie"]
            do {
                var temp = Set<String>()
                arr = arr.filter { temp.insert($0).inserted }
            }
            print(arr) // ["Mannie", "Moe", "Jack"]
        }
        
        do {
            let val = UIView.AnimationOptions.autoreverse.rawValue | UIView.AnimationOptions.repeat.rawValue
            let opts = UIView.AnimationOptions(rawValue: val)
            print(opts)
        }
        
        do {
            let opts : UIView.AnimationOptions = [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat]
            print(opts)
        }
        
        do {
            var opts = UIView.AnimationOptions.autoreverse
            opts.insert(.repeat) // compiler no longer complains
            print(opts)
        }
        
        do {
            let opts : UIView.AnimationOptions = [.autoreverse, .repeat]
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
        let recents = ud.object(forKey: RECENTS) as? [Int] ?? []
        var forbiddenNumbers = Set(recents)
        let legalNumbers = Set(1...PIXCOUNT).subtracting(forbiddenNumbers)
        let newNumber = legalNumbers.randomElement()!
        forbiddenNumbers.insert(newNumber)
        ud.set(Array(forbiddenNumbers), forKey:RECENTS)
    }


}

class MyTableViewCell : UITableViewCell {
    override func didTransition(to state: UITableViewCell.StateMask) {
        let editing = UITableViewCell.StateMask.showingEditControl.rawValue
        if state.rawValue & editing != 0 {
            // ... the ShowingEditControl bit is set ...
        }
    }
}

class MyTableViewCell2 : UITableViewCell {
    override func didTransition(to state: UITableViewCell.StateMask) {
        if state.contains(.showingEditControl) {
            // ... the ShowingEditControl bit is set ...
        }
    }
}


