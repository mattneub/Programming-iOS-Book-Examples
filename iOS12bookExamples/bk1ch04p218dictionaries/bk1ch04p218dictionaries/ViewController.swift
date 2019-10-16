

import UIKit

class Dog {}
class NoisyDog : Dog {}

extension Dictionary { // no longer needed in Swift 4!
    mutating func addEntries(from d:[Key:Value]) {
        for (k,v) in d {
            self[k] = v
        }
    }
}

struct Dog2 : Equatable {
    let name : String
    static func ==(lhs:Dog2,rhs:Dog2) -> Bool {
        return lhs.name == rhs.name
    }
}


class ViewController: UIViewController {
    
    var progress = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
        
            let d = [String:String]()
            var d2 = ["CA": "California", "NY": "New York"]
            let d3 : [String:String] = [:]
            
            let state = d2["CA"]
            d2["CA"] = "Casablanca"
            d2["MD"] = "Maryland"
            d2["NY"] = nil
            
            let state2 = d2["ZZ", default:"N/A"]
            print(state2)
            
            _ = d
            _ = d3
            _ = state
            
        }
        
        do {
            let abbrevs = ["CA", "NY"]
            let names = ["California", "New York"]
            let tuples = (abbrevs.indices).map{(abbrevs[$0],names[$0])}
            let d = Dictionary(uniqueKeysWithValues: tuples)
            print(d) // ["NY": "New York", "CA": "California"]
            
            let tuples2 = zip(abbrevs, names)
            let d2 = Dictionary(uniqueKeysWithValues: tuples2)
            print(d2) // ["NY": "New York", "CA": "California"]
        }
        
        do {
            let r = 1...
            let names = ["California", "New York"]
            let d = Dictionary(uniqueKeysWithValues:zip(r,names))
            print(d) // [2: "New York", 1: "California"]
            
        }
        
        do { // old way
            var sectionNames = [String]()
            var cellData = [[String]]()
            let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!)
            let states = s.components(separatedBy:"\n")
            var previous = ""
            for aState in states {
                // get the first letter
                let c = String(aState.prefix(1))
                // only add a letter to sectionNames when it's a different letter
                if c != previous {
                    previous = c
                    sectionNames.append(c.uppercased())
                    // and in that case also add new subarray to our array of subarrays
                    cellData.append([String]())
                }
                cellData[cellData.count-1].append(aState)
            }
            let d = Dictionary(uniqueKeysWithValues: zip(sectionNames,cellData))
            print(d)
        }
        
        do { // new way
            let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!)
            let states = s.components(separatedBy:"\n")
            let d = Dictionary(grouping: states) {$0.prefix(1).uppercased()}
            print(d)
        }
        
        do {
            let sentence = "how much wood would a wood chuck chuck"
            let words = sentence.split(separator: " ").map{String($0)}
            // old approach
            var d = [String:Int]()
            for word in words {
                let ct = d[word]
                if ct != nil {
                    d[word]! += 1
                } else {
                    d[word] = 1
                }
            }
            print(d) // ["how": 1, "wood": 2, "a": 1, "chuck": 2, "would": 1, "much": 1]
            // new approach
            do {
                var d = [String:Int]()
                words.forEach {d[$0, default:0] += 1}
                print(d)
            }
            // here's a silly but interesting way to accomplish the same thing:
            do {
                let ones = Array(repeating: 1, count: words.count)
                let d = Dictionary(zip(words,ones)){$0+$1}
                print(d)
            }
        }

        do {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let d = ["fido": dog1, "rover": dog2]
            let d2 = d as! [String : NoisyDog]
            
            _ = d2
        }
        
        do {
            // not in book; trying to make elementsEqual work,
            // but it appears to work only if we sort on the keys first
            var d1 = [String:Dog2]()
            d1["dog"] = Dog2(name:"Fido")
            d1["doog"] = Dog2(name:"Fidro")
            var d2 = [String:Dog2]()
            d2["doog"] = Dog2(name:"Fidro")
            d2["dog"] = Dog2(name:"Fido")
            let ok = d1.sorted{$0.key<$1.key}.elementsEqual(d2.sorted{$0.key<$1.key}) {
                $0.key == $1.key && $0.value.name == $1.value.name
            }
            print(ok)
        }
        
        do {
            let d = ["CA": "California", "NY": "New York"]
            for s in d.keys {
                print(s)
            }
            
            let keys = Array(d.keys)
            
            for (abbrev, state) in d {
                print("\(abbrev) stands for \(state)")
            }
            
            for pair in d {
                print("\(pair.key) stands for \(pair.value)")
            }

            let arr = Array(d) // [(key: "NY", value: "New York"), (key: "CA", value: "California")]
            print(arr)
            
            _ = d
            _ = keys
            _ = arr
            

        }
        
        do {
            var d = ["CA": "California", "NY": "New York"]
            let ix = d.values.startIndex
            d.values[ix] = d.values[ix].uppercased()
            // d is now ["NY": "NEW YORK", "CA": "California"]
            print(d)
        }
        
        do {
            let d : [String:Int] = ["one":1, "two":2, "three":3]
            
            let sum = d.values.reduce(0, +)
            print(sum) // 6
            
            let min = d.values.min()
            print(min as Any) // Optional(1)
            
            let arr = d.values.filter{$0 < 2}
            print(arr) // [1]
            
            let keysSorted = d.keys.sorted()
            print(keysSorted) // ["one", "three", "two"]
            
            let ok = d.keys == ["one":1, "three":3, "two":2].keys // true
            print(ok)
        }
        
        do {
            let d = ["CA": "California", "NY": "New York"]
            let d2 = d.filter {$0.value > "New Jersey"}.mapValues{$0.uppercased()}
            print(d2) // ["NY": "NEW YORK"]
        }
        
        do {
            let d1 = ["CA": "California", "NY": "New York"]
            let d2 = ["MD": "Maryland", "NY": "New York"]
            let d3 = d1.merging(d2){orig, _ in orig}
            print(d3) // ["MD": "Maryland", "NY": "New York", "CA": "California"]
        }
        
        // also works with a sequence of tuples
        
        do {
            let d1 = ["CA": "California", "NY": "New York"]
            let d2 = [("MD","Maryland"), ("NY","New York")]
            let d3 = d1.merging(d2){orig, _ in orig}
            print(d3) // ["MD": "Maryland", "NY": "New York", "CA": "California"]
        }
        
        // yeccccccch!!!!!! Forced to take raw values because titleTextAttributes keys are String, not NSAttributedStringKey
        // yay!!!!! fixed in beta 4
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "ChalkboardSE-Bold", size: 20)!,
            .foregroundColor : UIColor.darkText,
            .shadow : {
                let shad = NSShadow()
                shad.shadowOffset = CGSize(width:1.5,height:1.5)
                return shad
            }()
        ]
        
        let nc = NotificationCenter.default
        // Cool and long-awaited new feature of Swift 2.2: no more string selectors
        // This means the compiler will form the actual selector for you
        // You don't even have to get it totally right! Here, I've used the bare name...
        // ...but Swift will still form the selector correctly for me
        // In other words, any valid reference to the method will do
        let test = Notification.Name("test")
        nc.addObserver(self, selector:#selector(notificationArrived), name: test, object: nil)
        print("posting junk")
        nc.post(name:test, object: self, userInfo: ["junk":3.0]) // not progress
        print("posting string")
        nc.post(name:test, object: self, userInfo: ["progress":"nonsense"]) // not a number
        print("posting 3")
        nc.post(name:test, object: self, userInfo: ["progress":3]) // not a double
        print("posting 3 as NSNumber")
        nc.post(name:test, object: self, userInfo: ["progress":3 as NSNumber]) // okay! that's kind of weird, eh
        print("posting 3.0")
        nc.post(name:test, object: self, userInfo: ["progress":3.0]) // okay!
        
        // testing what Itai Ferber says about not crossing the bridge
        nc.post(name:test, object: self, userInfo: ["progress":Dog2.init(name: "Fido")])

        // but this next example should prove unnecessary, I'm pretty sure; we can now append directly
        
        do {
            var d1 = ["NY":"New York", "CA":"California"]
            let d2 = ["MD":"Maryland"]
            // d1 += d2 // nope
            let mutd1 = NSMutableDictionary(dictionary:d1)
            mutd1.addEntries(from:d2)
            d1 = mutd1 as! [String:String] // no double cast needed, thank heavens
            // d1 is now ["MD": "Maryland", "NY": "New York", "CA": "California"]
            print(d1)
        }
        
        do { // no longer needed! :)
            var d1 = ["NY":"New York", "CA":"California"]
            let d2 = ["MD":"Maryland"]
            d1.addEntries(from:d2)
            print(d1)
        }

    }
    
    @objc func notificationArrived(_ n:Notification) {
        // track bridge crossing
        if let prog = n.userInfo?["progress"] {
            print(type(of:prog))
        }
        let prog = n.userInfo?["progress"] as? Double // no double cast needed so let's just cast all the way
        // however, note that this will not catch e.g. 3, whereas NSNumber doubleValue does, either in post or like this:
        // let prog = n.userInfo?["progress"] as? NSNumber as? Double
        // I've reported this as a bug; at the very least, it's likely to catch someone out
        // https://bugs.swift.org/browse/SR-5525
        // however, Itai Ferber says it's not a bug because `["progress":3]` never crossed the bridge in the first place
        if prog != nil {
            self.progress = prog!
            print("at last! \(self.progress)")
        } else {
            print("invalid notification")
        }
        let prog2 = n.userInfo?["progress"] as? Dog2 // proving that we are boxed
        if prog2 != nil {
            print("I got \(prog2!.name)")
        }
    }

    func anotherWay(_ n:Notification) {
        if let prog = n.userInfo?["progress"] as? Double { // chapter 10
            self.progress = prog
        }
    }
    
}

