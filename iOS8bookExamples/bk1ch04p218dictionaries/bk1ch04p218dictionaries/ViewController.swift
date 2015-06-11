

import UIKit

class Dog {}
class NoisyDog : Dog {}

extension Dictionary {
    mutating func addEntriesFromDictionary(d:[Key:Value]) {
        for (k,v) in d {
            self[k] = v
        }
    }
}


class ViewController: UIViewController {
    
    var progress = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        var d = [String:String]()
        var d2 = ["CA": "California", "NY": "New York"]
        var d3 : [String:String] = [:]
        
        let state = d2["CA"]
        d2["CA"] = "Casablanca"
        d2["MD"] = "Maryland"
        d2["NY"] = nil


        if true {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let d = ["fido": dog1, "rover": dog2]
            let d2 = d as! [String : NoisyDog]
        }
        
        if true {
            var d1 = ["NY":"New York", "CA":"California"]
            let d2 = ["MD":"Maryland"]
            let mutd1 = NSMutableDictionary(dictionary:d1)
            mutd1.addEntriesFromDictionary(d2)
            d1 = mutd1 as [NSObject:AnyObject] as! [String:String]
            // d1 is now ["MD": "Maryland", "NY": "New York", "CA": "California"]
            println(d1)
        }
        
        if true {
            var d = ["CA": "California", "NY": "New York"]
            for s in d.keys {
                println(s)
            }
            
            var keys = d.keys.array
            
            for (abbrev, state) in d {
                println("\(abbrev) stands for \(state)")
            }

            let arr = Array(d) // [("NY", "New York"), ("CA", "California")]

        }
        
        let dnums : [String:Int] = ["one":1, "two":2]
        let sum = reduce(dnums.values, 0, +)
        println(sum)

        let shad = NSShadow()
        shad.shadowOffset = CGSizeMake(1.5,1.5)
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : UIFont(name: "ChalkboardSE-Bold", size: 20)!,
            NSForegroundColorAttributeName : UIColor.darkTextColor(),
            NSShadowAttributeName : shad
        ]
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "notificationArrived:", name: "test", object: nil)
        nc.postNotificationName("test", object: self, userInfo: ["junk":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":3])
    }
    
    func notificationArrived(n:NSNotification) {
        let prog = n.userInfo?["progress"] as? NSNumber
        if prog != nil {
            self.progress = prog!.doubleValue
            println("at last! \(self.progress)")
        }
    }


}

