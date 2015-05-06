

import UIKit

protocol Flier {
}
struct Bird : Flier {
}
struct Insect : Flier {
}
class Dog {
}
class NoisyDog : Dog {
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if true {
            var arr = [Int]()
        }
        
        if true {
            var arr : [Int] = []
        }
        
        if true {
            // let arr = [Insect(), Bird()] // compile error
            let arr : [Flier] = [Insect(), Bird()]
            let strings : [String?] = Array(count:100, repeatedValue:nil)
        }
        
        if true {
            let arr : [Int?] = [1,2,3]
            println(arr) // [Optional(1), Optional(2), Optional(3)]
        }
        
        if true {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let arr = [dog1, dog2]
            if arr is [NoisyDog] {
                println("yep") // meaning it can be cast down
            }
            let arr2 = arr as! [NoisyDog]
        }
        
        if true {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let dog3 : Dog = Dog()
            let arr = [dog1, dog2]
            let arr2 = arr as? [NoisyDog] // Optional wrapping an array of NoisyDog
            let arr3 = [dog2, dog3]
            let arr4 = arr3 as? [NoisyDog] // nil
        }
        
        if true {
            let i1 = 1
            let i2 = 2
            let i3 = 3
            if [1,2,3] == [i1,i2,i3] { // they are equal!
                println("equal")
            }
            
            let nd1 = NoisyDog()
            let d1 = nd1 as Dog
            let nd2 = NoisyDog()
            let d2 = nd2 as Dog
            if [d1,d2] == [nd1,nd2] { // they are equal!
                println("equal")
            }
        }
        
        if true {
            var arr = [1,2,3]
            arr[1] = 4 // arr is now [1,4,3]
            arr[1..<2] = [7,8] // arr is now [1,7,8,3]
            arr[1..<2] = [] // arr is now [1,8,3]
        }
        
        if true {
            var arr = [[1,2,3], [4,5,6], [7,8,9]]
            let i = arr[1][1] // 5
            arr[1][1] = 100
        }
        
        if true {
            let arr = [1,2,3]
            let arr2 = arr[arr.count-2...arr.count-1] // [2,3]
            let arr3 = suffix(arr,2) // [2,3]
        }
        
        if true {
            let arr : [Int?] = [1,2,3]
            let i = arr.last // a double-wrapped Optional
        }
        
        if true {
            var arr = [1,2,3]
            arr.append(4)
            arr.extend([5,6])
            arr.extend(7...8) // arr is now [1,2,3,4,5,6,7,8]
            
            let arr2 = arr + [4] // arr2 is now [1,2,3,4]
            var arr3 = [1,2,3]
            arr3 += [4] // arr3 is now [1,2,3,4]

        }
        
        if true {
            let arr = [[1,2], [3,4], [5,6]]
            let arr2 = [10,11].join(arr) // [1, 2, 10, 11, 3, 4, 10, 11, 5, 6]
            let arr3 = [].join(arr) // [1, 2, 3, 4, 5, 6]
            let arr4 = arr.flatMap {$0} // new in Swift 1.2
        }
        
        if true {
            var arr = [4,3,5,2,6,1]
            arr.sort {$0 < $1} // [1, 2, 3, 4, 5, 6]
            arr = [4,3,5,2,6,1]
            arr.sort(<) // [1, 2, 3, 4, 5, 6]
        }
        
        if true {
            let arr = [1,2,3]
            let ok = contains(arr,2)
            let ix = find(arr,2) // Optional wrapping 1
            let ok2 = startsWith(arr, [1,2]) {$0 == $1}
            let ok3 = startsWith(arr, [1,2], ==)
        }
        
        if true {
            let arr = [3,1,2]
            let min = minElement(arr) // 1
        }
        
        if true {
            let arr = [1,2,3,4,5,6]
            let arr2 = split(arr) {$0 % 2 == 0} // split at evens: [[1], [3], [5]]
        }

        let pepboys = ["Manny", "Moe", "Jack"]
        for pepboy in pepboys {
            println(pepboy) // prints Manny, then Moe, then Jack
        }
        for (ix,pepboy) in enumerate(pepboys) {
            println("Pep boy \(ix) is \(pepboy)") // Pep boy 0 is Manny, etc.
        }
        let arr = [1,2,3]
        let arr2 = arr.map {$0 * 2} // [2,4,6]
        let arr3 = arr.map {Double($0)} // [1.0, 2.0, 3.0]
        pepboys.map {println($0)} // prints Manny, then Moe, then Jack
        pepboys.map(println)
        let arr4 = pepboys.filter{$0.hasPrefix("M")} // [Manny, Moe]

        let arrr = Array(1...100)
        let sum = arrr.reduce(0) {$0 + $1} // 5050
        let sum2 = arrr.reduce(0, combine:+)

        if true {
            let arr = [[1,2], [3,4], [5,6]]
            let flat = arr.reduce([], combine:+) // [1, 2, 3, 4, 5, 6]
        }
        
        if true {
            let arr = [["Manny", "Moe", "Jack"], ["Harpo", "Chico", "Groucho"]]
            let target = "m"
            let arr2 = arr.map {
                $0.filter {
                    let options = NSStringCompareOptions.CaseInsensitiveSearch
                    let found = $0.rangeOfString(target, options: options)
                    return (found != nil)
                }
                }.filter {$0.count > 0}
            println(arr2)
        }
        
        if true {
            let arr = [UIBarButtonItem(), UIBarButtonItem()]
            self.navigationItem.leftBarButtonItems = arr
            self.navigationItem.setLeftBarButtonItems(arr, animated: true)
        }
        
        if true {
            let arr = ["Manny", "Moe", "Jack"]
            // let s = arr.componentsJoinedByString(", ") // compile error
            let s = (arr as NSArray).componentsJoinedByString(", ")
            let arr2 = NSMutableArray(array:arr)
            arr2.removeObject("Moe")
        }
        
        if true {
            let arrCGPoints = [CGPoint]()
            let arrNSValues = arrCGPoints.map { NSValue(CGPoint:$0) }
        }
        
        if true {
            let arr = [String?]()
            // let arr2 = arr.map{if $0 == nil {return NSNull()} else {return $0!}} // compile error
            let arr2 : [AnyObject] = arr.map{if $0 == nil {return NSNull()} else {return $0!}}
        }
        
        if true {
            let arr = UIFont.familyNames()
            let arr2 = UIFont.familyNames() as! [String]
            let views = self.view.subviews as! [UIView]
        }
        
        if true {
            let arr = [AnyObject]()
            let arr2 : [String] = arr.map {
                if $0 is String {
                    return $0 as! String
                } else {
                    return ""
                }
            }
        }

    }

}

