

import UIKit

protocol Flier {
}
struct Bird : Flier {
    var name = "Tweety"
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

        do {
            var arr = [Int]()
            _ = arr
            arr = []
        }
        
        do {
            var arr : [Int] = []
            _ = arr
            arr = []
        }
        
        do {
            let dogs = [Dog(), NoisyDog()]
            let objs = [1, "howdy"]
            // let arrr = [Insect(), Bird()] // compile error
            let arr : [Flier] = [Insect(), Bird()]
            
            do {
                let arr2 : [Flier] = [Insect()]
                // WARNING next line is legal (compiles) but you'll crash at runtime
                // can't use array-casting to cast down from protocol type to adopter type
                // let arr3 = arr2 as! [Insect]
                _ = arr2
            }
            
            do {
                let arr2 : [Flier] = [Insect()]
                // instead of above, to cast down, must cast individual elements down
                let arr3 = arr2.map{$0 as! Insect}
                _ = arr2
                _ = arr3
            }
            
            let rs = Array(1...3)
            print(rs)
            let chars = Array("howdy".characters)
            print(chars)
            let kvs = Array(["hey":"ho", "nonny":"nonny no"])
            print(kvs)
            let strings : [String?] = Array(repeating:nil, count:100)
            _ = arr
            _ = strings
            _ = dogs
            _ = objs
        }
        
        do {
            let arr : [Int?] = [1,2,3]
            print(arr) // [Optional(1), Optional(2), Optional(3)]
        }
        
        do {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let arr = [dog1, dog2]
            if arr is [NoisyDog] {
                print("yep") // meaning it can be cast down
            }
            let arr2 = arr as! [NoisyDog]
            _ = arr2
        }
        
        do {
            let dog1 : Dog = NoisyDog()
            let dog2 : Dog = NoisyDog()
            let dog3 : Dog = Dog()
            let arr = [dog1, dog2]
            let arr2 = arr as? [NoisyDog] // Optional wrapping an array of NoisyDog
            let arr3 = [dog2, dog3]
            let arr4 = arr3 as? [NoisyDog] // nil
            _ = arr2
            _ = arr4
        }
        
        do {
            let i1 = 1
            let i2 = 2
            let i3 = 3
            let arr : [Int] = [1,2,3]
            if arr == [i1,i2,i3] { // they are equal!
                print("equal")
            }
            
            let nd1 = NoisyDog()
            let d1 = nd1 as Dog
            let nd2 = NoisyDog()
            let d2 = nd2 as Dog
            if [d1,d2] == [nd1,nd2] { // they are equal!
                print("equal")
            }
        }
        
        do {
            let arr = ["manny", "moe", "jack"]
            let slice = arr[1...2]
            print(slice)
            print("slice:", slice[1]) // moe
            let arr2 = Array(slice)
            print("array:", arr2[1]) // jack
        }
        
        do {
            var arr = [1,2,3]
            arr[1] = 4 // arr is now [1,4,3]
            arr[1..<2] = [7,8] // arr is now [1,7,8,3]
            arr[1..<2] = [] // arr is now [1,8,3]
            arr[1..<1] = [10] // arr is now [1,10,8,3] (no element was removed!)

            let slice = arr[1..<2]
            _ = slice
        }
        
        do {
            var arr = [[1,2,3], [4,5,6], [7,8,9]]
            let i = arr[1][1] // 5
            arr[1][1] = 100
            _ = i
        }
        
        do {
            let arr = [1,2,3]
            print(arr.first)
            print(arr.last)
            let slice = arr[arr.count-2...arr.count-1] // [2,3]
            let slice2 = arr.suffix(2) // [2,3]
            let slice3 = arr.suffix(10) // [1,2,3] with no penalty
            let slice4 = arr.prefix(2)
            print(slice3)
            
            // new in beta 6
            
            do {
                let slice = arr.suffix(from:1)
                print(slice)
                let slice2 = arr.prefix(upTo:1)
                print(slice2)
                let slice3 = arr.prefix(through:1)
                print(slice3)
            }
            
            // let arr5 = arr[0..<10]
            
            do {
                let slice = arr.suffix(from:1)
                print(arr.startIndex)
                print(slice.startIndex) // 1
                print(slice.indices) // 1..<3
            }
            
            
            do {
                let arr = [1,2,3]
                let slice = arr[arr.startIndex-2..<arr.endIndex] // [2,3]
                print(slice)
                print(slice.indices)
                print(slice.startIndex)
            }
 
            
            _ = (slice, slice2, slice3, slice4)
        }
        
        do {
            let arr : [Int?] = [1,2,3]
            let i = arr.last // a double-wrapped Optional
            _ = i
        }
        
        do {
            let arr = [1,2,3]
            let ok = arr.contains(2) // ***
            let okk = arr.contains {$0 > 3} // false
            let ix = arr.index(of:2) // *** Optional wrapping 1
            
            let aviary = [Bird(name:"Tweety"), Bird(name:"Flappy"), Bird(name:"Lady")]
            let ix2 = aviary.index {$0.name.characters.count < 5} // index(where:)
            print(ix2)
            
            do {
                let ok = arr.starts(with:[1,2])
                let ok2 = arr.starts(with:[1,2]) {$0 == $1} // ***
                let ok3 = arr.starts(with:[1,2], isEquivalent:==) // ***
                let ok4 = arr.starts(with:[1,2])
                let ok5 = arr.starts(with:1...2)
                let ok6 = arr.starts(with:[1,-2]) {abs($0) == abs($1)}
                
                _ = ok
                _ = ok2
                _ = ok3
                _ = ok4
                _ = ok5
                _ = ok6
            }
            _ = ok
            _ = okk
            _ = ix
        }

        do {
            let arr = [3,1,-2]
            let min = arr.min() // *** -2
            print(min)
            let min2 = arr.min {abs($0)<abs($1)}
            print(min2)
        }
        
        do {
            var arr = [1,2,3]
            arr.append(4)
            arr.append(contentsOf:[5,6])
            arr.append(contentsOf:7...8) // arr is now [1,2,3,4,5,6,7,8]
            
            let arr2 = arr + [4] // arr2 is now [1,2,3,4]
            var arr3 = [1,2,3]
            arr3 += [4] // arr3 is now [1,2,3,4]
            _ = arr2

        }
        
        do {
            var arr = [1,2,3]
            arr.insert(4, at:1)
            print(arr)
            arr.insert(contentsOf:[10,9,8], at:1)
            print(arr)
            let i = arr.remove(at:3)
            let ii = arr.removeLast() // returns a result
            arr.removeLast(1) // doesn't return a result
            let iii = arr.removeFirst() // returns a result
            arr.removeFirst(1) // doesn't return a result
            let iiii = arr.popLast()
            // arr.popLast(1) // nope, no such thing
            // let iiiii = arr.popFirst()
            print(arr)
            do {
                // let iiii = arr.popFirst() // nope
                var arrslice = arr[arr.indices] // is this weird or what
                let i = arrslice.popFirst()
                // let ii = arrslice.popFirst(1)
                print(i)
                print(arrslice)
                print(arr) // untouched, of course
            }
            print(arr)
            _ = i
            _ = ii
            _ = iii
            let slice = arr.dropFirst()
            let slice2 = arr.dropLast()
            let slice3 = arr.dropFirst(100)
            print("slice3", slice3)
            _ = slice
            _ = slice2
            _ = slice3
            _ = iiii
        }
        
        do {
            let arr = [[1,2], [3,4], [5,6]]
            let joined = arr.joined(separator: [10,11]) // [1, 2, 10, 11, 3, 4, 10, 11, 5, 6]
            let joined2 = arr.joined(separator: []) // [1, 2, 3, 4, 5, 6]
            let arr4 = arr.flatMap {$0} // new in Swift 1.2
            let arr5 = Array(arr.flatten()) // new in Xcode 7 beta 6
            _ = joined
            _ = joined2
            _ = arr4
            _ = arr5
        }
        
        do {
            var arr = [4,3,5,2,6,1]
            arr.sort()
            arr.sort {$0 > $1} // *** [1, 2, 3, 4, 5, 6]
            arr = [4,3,5,2,6,1]
            arr.sort(isOrderedBefore: >) // *** [1, 2, 3, 4, 5, 6]
            
        }
        
        do {
            let arr = [1,2,3,4,5,6]
            let arr2 = arr.split {$0 % 2 == 0} // split at evens: [[1], [3], [5]]
            print(arr2)
            _ = arr2
        }

        let pepboys = ["Manny", "Moe", "Jack"]
        for pepboy in pepboys {
            print(pepboy) // prints Manny, then Moe, then Jack
        }
        for (ix,pepboy) in pepboys.enumerated() { // ***
            print("Pep boy \(ix) is \(pepboy)") // Pep boy 0 is Manny, etc.
        }
        let arr = [1,2,3]
        let arr2 = arr.map {$0 * 2} // [2,4,6]
        let arr3 = arr.map {Double($0)} // [1.0, 2.0, 3.0]
        pepboys.forEach {print($0)} // prints Manny, then Moe, then Jack
        pepboys.enumerated().forEach {print("Pep boy \($0.0) is \($0.1)")}
        // pepboys.map(print) // no longer compiles
        let arr4 = pepboys.filter{$0.hasPrefix("M")} // [Manny, Moe]

        let arrr = [1, 4, 9, 13, 112]
        let sum = arrr.reduce(0) {$0 + $1} // 139
        let sum2 = arrr.reduce(0, combine:+)

        _ = arr2
        _ = arr3
        _ = arr4
        _ = sum
        _ = sum2

        do {
            let sec = 0
            let ct = 10
            _ = Array(0..<ct).map {IndexPath(row:$0, section:sec)}
            _ = (0..<ct).map {IndexPath(row:$0, section:sec)}

        }
        
        do {
            let arr = [[1,2], [3,4], [5,6]]
            let flat = arr.reduce([], combine:+) // [1, 2, 3, 4, 5, 6]
            _ = flat
            
            let arr2 = [[1,2], [3,4], [5,6], 7]
            let arr3 = arr2.flatMap {$0}
            print(arr3)
        }
        
        // flatMap has another use that I really should talk about:
        // it unwraps Optionals safely while eliminating nils
        do {
            let arr : [String?] = ["Manny", nil, nil, "Moe", nil, "Jack", nil]
            let arr2 = arr.flatMap{$0}
            print(arr2)
        }
        
        do {
            let arr = [["Manny", "Moe", "Jack"], ["Harpo", "Chico", "Groucho"]]
            let target = "m"
            let arr2 = arr.map {
                $0.filter {
                    let options = String.CompareOptions.caseInsensitiveSearch
                    let found = $0.range(of:target, options: options)
                    return (found != nil)
                }
                }.filter {$0.count > 0}
            print(arr2)
        }
        
        do {
            let arr = [UIBarButtonItem(), UIBarButtonItem()]
            self.navigationItem.leftBarButtonItems = arr
            self.navigationItem.setLeftBarButtonItems(arr, animated: true)
        }
        
        do {
            var arr = ["Manny", "Moe", "Jack"]
            // let ss = arr.componentsJoined(by:", ") // compile error
            let s = (arr as NSArray).componentsJoined(by:", ")
            let arr2 = NSMutableArray(array:arr)
            arr2.remove("Moe")
            arr = arr2 as NSArray as! [String]
            print(arr)
            
            _ = s
            
        }
        
        do {
            let arrCGPoints = [CGPoint]()
            // let arrr = arrCGPoints as NSArray // compiler stops you
            let arrNSValues = arrCGPoints.map { NSValue(cgPoint:$0) }
            let arr = arrNSValues as NSArray
            _ = arrNSValues
            _ = arr
        }
        
        do {
            let arr = [String?]()
            // let arr2 = arr.map{if $0 == nil {return NSNull()} else {return $0!}} // compile error
            // let arr2 = arr.map{s -> AnyObject in if s == nil {return NSNull()} else {return s!}}
            let arr2 : [AnyObject] =
                arr.map {if $0 != nil {return $0!} else {return NSNull()}}
            _ = arr2
        }
        
        do {
            // the API is fixed!
            let arr = UIFont.familyNames().map {
                UIFont.fontNames(forFamilyName: $0)
            }
            print(arr)
            let views = self.view.subviews
            _ = arr
            _ = views
            // but you can still receive an untyped array
            let p = Pep()
            let boys = p.boys() as! [String]
            print(boys)
            let boys2 = p.boysGood() // it's already a [String]
            print(boys2)
        }
        
        do {
            let arr = [AnyObject]()
            let arr2 : [String] = arr.map {
                if $0 is String {
                    return $0 as! String
                } else {
                    return ""
                }
            }
            _ = arr2
        }
        
        do {
            // there seems to be some doubt now as to whether the medium of exchange...
            // ... is AnyObject or NSObject
            let s = "howdy" as NSObject
            let s2 = "howdy" as AnyObject
            let s3 = s as! String
            let s4 = s2 as! String
            print(s3, s4)
            let arr = [Dog()]
            let nsarr = arr as NSArray
            // there is no problem even if it is NOT an NSObject, so what's the big deal?
            print(nsarr.object(at:0))
            
            let arr2 = ["howdy", Dog()]
            let nsarr2 = arr2 as NSArray
            print(nsarr2)
            
        }

    }

}

