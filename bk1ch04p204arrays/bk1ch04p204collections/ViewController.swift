

import UIKit

protocol Flier {
}
struct Bird : Flier {
    var name = "Tweety"
}
struct Insect : Flier {
}
class DogNOT : Equatable { // WHOA! New in seed 6, we are not automatically equatable
    // we can make ourselves equatable easily enough
    static func ==(lhs:DogNOT, rhs:DogNOT) -> Bool {
        return lhs === rhs
    }
}
class NoisyDogNOT : DogNOT {
}

// however, even though that works, for teaching purposes I'm going to use NSObject to solve it

class Dog : NSObject {}
class NoisyDog : Dog {}

// not in the book, just a useful extension I got off Stack Overflow http://stackoverflow.com/a/38156873/341994

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
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
            // let objs2 = [1, "howdy"] // compile error
            let objs : [Any] = [1, "howdy"] // explicit type annotation needed
            // let arrr = [Insect(), Bird()] // compile error
            let arr : [Flier] = [Insect(), Bird()]
            
            do {
                let arr2 : [Flier] = [Insect()]
                // WARNING next line is legal (compiles) but you'll crash at runtime
                // can't use array-casting to cast down from protocol type to adopter type
                // Wait, they fixed that in Xcode 8 seed 6!
                let arr3 = arr2 as! [Insect]
                print("I didn't crash! I kiss the sweet ground...")
                _ = (arr2, arr3)
            }
            
            /*
            do {
                let arr2 : [Flier] = [Insect()]
                // instead of above, to cast down, must cast individual elements down
                let arr3 = arr2.map{$0 as! Insect}
                _ = arr2
                _ = arr3
            }
 */
            
            let rs = Array(1...3)
            print(rs)
            let chars = Array("howdy")
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
            let dogs = Array(repeating:Dog(), count:3)
            print(dogs[0] === dogs[1])
            let dogs2 = (0..<3).map{_ in Dog()}
            print(dogs2[0] === dogs2[1])
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
            print(arr2 as Any, arr4 as Any)
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
//            let base = slice.base
//            print("base:", slice.base)
        }
        
        do {
            var arr = [1,2,3]
            arr[1] = 4 // arr is now [1,4,3]
            arr[1..<2] = [7,8] // arr is now [1,7,8,3]
            arr[1..<2] = [] // arr is now [1,8,3]
            arr[1..<1] = [10] // arr is now [1,10,8,3] (no element was removed!)
            let arr2 = [20,21]
            // arr[1..<1] = arr2 // compile error!
            arr[1..<1] = ArraySlice(arr2)
            print("after all that:", arr)


            let slice = arr[1..<2]
            _ = slice
            
            // _ = arr[-1] // amazing that this compiles
        }
        
        do {
            var arr = [1,2,3]
            print(arr[1...])
            print(arr[...1])
            arr[1...] = [4,5]
            print(arr)
        }
        
        do {
            var arr = [[1,2,3], [4,5,6], [7,8,9]]
            let i = arr[1][1] // 5
            arr[1][1] = 100
            print(arr)
            _ = i
            let arr2 = [[1,2]]
            let ok = arr == arr2 // compile error before Swift 4.1, but not any more!
            // let ok = arr.elementsEqual(arr2, by:==) // no need for this trick
            print(ok)
        }
        
        do {
            let arr = [1,2,3]
            print(arr.first as Any)
            print(arr.last as Any)
            let slice = arr[arr.count-2...arr.count-1] // [2,3]
            let slice2 = arr.suffix(2) // [2,3]
            let slice3 = arr.suffix(10) // [1,2,3] with no penalty
            let slice4 = arr.prefix(2)
            print(slice3)
            
            // new in beta 6
            
            do {
                let slice = arr.suffix(from:1)
                print(slice)
                let slice2 = arr[1...]
                print(slice2)
                let slice3 = arr.prefix(upTo:1)
                print(slice3)
                let slice4 = arr.prefix(through:1)
                print(slice4)
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
                let slice = arr[arr.endIndex-2..<arr.endIndex] // [2,3]
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
            let ix = arr.firstIndex(of:2) // *** Optional wrapping 1
            let which = arr.firstIndex {$0>2}
            let which2 = arr.first {$0>2}
            
            let aviary = [Bird(name:"Tweety"), Bird(name:"Flappy"), Bird(name:"Lady")]
            // let ixxxx = aviary.firstIndex(of:Bird(name:"Tweety"))
            let ix2 = aviary.firstIndex {$0.name.count < 5}
            print(ix2 as Any)
            
            do {
                let ok = arr.starts(with:[1,2])
                let ok2 = arr.starts(with:[1,2]) {$0 == $1} // ***
                let ok3 = arr.starts(with:[1,2], by:==) // ***
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
            _ = (which, which2)
        }
        
        do {
            let arr = [1,2,3]
            let r = 1...3
            let ok = arr.elementsEqual(r) // no need to specify ==, Int is Equatable
            print(ok)
        }
        
        do {
            let arr1 = [Dog2(name:"Fido"), Dog2(name:"Rover")]
            let arr2 = [Dog2(name:"Fido"), Dog2(name:"Rover")]
            let ok = arr1.elementsEqual(arr2) {$0.name == $1.name}
            print(ok)
        }

        do {
            let arr = [3,1,-2]
            let min = arr.min() // *** -2
            print(min as Any)
            let min2 = arr.min {abs($0)<abs($1)}
            print(min2 as Any)
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
                print(i as Any)
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
            let joined3 = arr.joined(separator: 8...9) // just proving that other sequences are legal
            let arr4 = arr.flatMap {$0} // new in Swift 1.2
            let arr5 = Array(arr.joined()) // renamed in Xcode 8 seed 6 *
            // let arr6 = Array(arr.flatten())
            _ = joined
            _ = joined2
            _ = joined3
            _ = arr4
            _ = arr5
        }
        
        do {
            var arr = [4,3,5,2,6,1]
            arr.sort()
            arr.sort {$0 > $1} // *** [1, 2, 3, 4, 5, 6]
            arr = [4,3,5,2,6,1]
            arr.sort(by:>) // *** [1, 2, 3, 4, 5, 6]
            
        }
        
        do {
            let arr = [1,2,3,4,5,6]
            let arr2 = arr.split {$0 % 2 == 0} // split at evens: [[1], [3], [5]]
            print(arr2)
            _ = arr2
        }
        
        do {
            var arr = [1,2,3]
            arr.swapAt(0,2) // [3,2,1]
            print(arr)
        }

        let pepboys = ["Manny", "Moe", "Jack"]
        for pepboy in pepboys {
            print(pepboy) // prints Manny, then Moe, then Jack
        }
        for (ix,pepboy) in pepboys.enumerated() { // ***
            print("Pep boy \(ix) is \(pepboy)") // Pep boy 0 is Manny, etc.
        }
        pepboys.forEach {print($0)} // prints Manny, then Moe, then Jack
        pepboys.enumerated().forEach {
            print("Pep boy \($0.offset) is \($0.element)")
        }
        
        _ = [1,2,3,4].randomElement()!

        let ok = pepboys.allSatisfy {$0.hasPrefix("M")} // false
        print(ok)
        
        let ok2 = pepboys.allSatisfy {$0.hasPrefix("M") || $0.hasPrefix("J")} // true
        print(ok2)

        
        
        let arr = [1,2,3]
        let arr2 = arr.map {$0 * 2} // [2,4,6]
        let arr3 = arr.map {Double($0)} // [1.0, 2.0, 3.0]
        // pepboys.map(print) // no longer compiles
        let arr4 = pepboys.filter{$0.hasPrefix("M")} // ["Manny", "Moe"]
        
        do {
            var pepboys = ["Manny", "Jack", "Moe"]
            pepboys.removeAll{$0.hasPrefix("M")} // pepboys is now ["Jack"]
            print(pepboys)
            pepboys = ["Manny", "Jack", "Moe"]
            let pepboys2 = pepboys.filter{!$0.hasPrefix("M")}
            print(pepboys2)
        }
        
        do {
            let pepboys = ["Manny", "Jack", "Moe"]
            let arr1 = pepboys.filter{$0.hasPrefix("M")} // ["Manny", "Moe"]
            let arr2 = pepboys.prefix{$0.hasPrefix("M")} // ["Manny"]
            let arr3 = pepboys.drop{$0.hasPrefix("M")} // ["Jack", "Moe"]
            print(arr1)
            print(arr2)
            print(arr3)
        }

        let arrr = [1, 4, 9, 13, 112]
        let sum = arrr.reduce(0) {$0 + $1} // 139
        let sum2 = arrr.reduce(0, +)

        _ = arr2
        _ = arr3
        _ = arr4
        _ = sum
        _ = sum2
        
        do {
            // interesting misuse of `reduce`: implement each_cons
            // this is probably incredibly inefficient but it was fun to write
            let arr = [1,2,3,4,5,6,7,8]
            let clump = 2
            let cons : [[Int]] = arr.reduce([[Int]]()) {
                memo, cur in
                var memo = memo
                if memo.count == 0 {
                    return [[cur]]
                }
                if memo.count < arr.count - clump + 1 {
                    memo.append([])
                }
                return memo.map {
                    if $0.count == clump {
                        return $0
                    }
                    var arr = $0
                    arr.append(cur)
                    return arr
                }
            }
            print(cons)
        }
        
        // new in Xcode 9 beta 5, at last reduce(into:) comes into being!
        do {
            let arr = [("one",1), ("two",2), ("three",3)]
            let (keys,values) : ([String], [Int]) = arr.reduce(into: ([],[])) {
                acc, pair in acc.0.append(pair.0); acc.1.append(pair.1)
            }
            print(keys)
            print(values)
        }
        
        do {
            // implementation of each_slice
            // but see Martin R's https://stackoverflow.com/a/27985246/341994, might be better
            let arr = [1,2,3,4,5,6,7,8,9]
            let clump = 2
            let slices : [[Int]] = arr.reduce(into:[]) {
                memo, cur in
                if memo.count == 0 {
                    return memo.append([cur])
                }
                if memo.last!.count < clump {
                    memo.append(memo.removeLast() + [cur])
                } else {
                    memo.append([cur])
                }
            }
            print(slices)
        }
        
        do {
            let nums = [1,3,2,4,5]
            let result = nums.reduce(into: [[],[]]) { temp, i in
                temp[i%2].append(i)
            }
            print(result)
            // result is now [[2, 4], [1, 3, 5]]
        }

        do {
            let sec = 0
            let ct = 10
            _ = Array(0..<ct).map {IndexPath(row:$0, section:sec)}
            _ = (0..<ct).map {IndexPath(row:$0, section:sec)}

        }
        
        // these are legal uses of flatMap in Swift 4.1, plus another way to flatten
        
        do {
            let arr = [[1],[2]].flatMap{$0}
            print(arr)
        }
        
        do {
            let arr = [[1,2], [3,4], [5,6]]
            let flat = arr.reduce([], +) // [1, 2, 3, 4, 5, 6]
            print(flat)
            
//            let arr2 : [Any] = [[1,2], [3,4], [5,6], 7] // must be explicit [Any]
//            let arr3 = arr2.flatMap {$0}
//            print(arr3)
        }
        
        do {
            let arr = [[1, 2], [3, 4]]
            let arr2 = arr.flatMap{$0.map{String($0)}} // ["1", "2", "3", "4"]
            print(arr2)
        }
        
        // flatMap second use has been changed to compactMap in Swift 4.1
        // it unwraps Optionals safely while eliminating nils
        do {
            let arr : [String?] = ["Manny", nil, nil, "Moe", nil, "Jack", nil]
            let arr2 = arr.compactMap{$0}
            print(arr2)
        }
        
        do {
            let arr : [Any] = [1, "hey", 2, "ho"] // NOT AnyObject! No automatic bridge-crossing
            let arr2 = arr.compactMap{$0 as? String} // ["hey", "ho"]
            print(arr2)
            
            // let arrr : [AnyObject] = ["howdy"] // illegal
        }
        
        do { // better example
            let arr = ["1", "hey", "2", "ho"]
            let arr2 = arr.compactMap{Int($0)} // [1, 2]
            print(arr2)
        }
        
        do {
            let arr = [["Manny", "Moe", "Jack"], ["Harpo", "Chico", "Groucho"]]
            let target = "m"
            let arr2 = arr.map {
                $0.filter {
                    let found = $0.range(of:target, options: .caseInsensitive)
                    return (found != nil)
                }
                }.filter {$0.count > 0}
            print(arr2)
            // [["Manny", "Moe"]]

        }
        
        do {
            let arr = [UIBarButtonItem(), UIBarButtonItem()]
            self.navigationItem.leftBarButtonItems = arr
            self.navigationItem.setLeftBarButtonItems(arr, animated: true)
        }
        
        do {
            let lay = CAGradientLayer()
            lay.locations = [0.25, 0.5, 0.75]
        }
        
        do {
            let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.position)) // dummy
            let (oldP,p1,p2,newP) = (CGPoint.zero,CGPoint.zero,CGPoint.zero,CGPoint.zero) // dummy
            let points = [oldP,p1,p2,newP]
            anim.values = points.map {NSValue(cgPoint:$0)}
            // this, on the other hand, is _legal_, but it isn't going to work:
            anim.values = points
            // FLASH! New in Xcode 8.1 it _is_ going to work
        }
        
        do {
            var arr = ["Manny", "Moe", "Jack"]
            // let ss = arr.componentsJoined(by:", ") // compile error
            let s = (arr as NSArray).componentsJoined(by:", ")
            let arr2 = NSMutableArray(array:arr)
            arr2.remove("Moe")
            arr = arr2 as! [String] // double cast no longer needed!
            print(arr)
            
            _ = s
            
        }
        
        do {
            let arrCGPoints = [CGPoint()]
            let arr = arrCGPoints as NSArray // this is now LEGAL (Xcode 8, seed 6)
            // let arrNSValues = arrCGPoints.map { NSValue(cgPoint:$0) }
            // let arr = arrNSValues as NSArray
            print(arr)
        }
        
        do {
            let arr = [String?]()
            // let arr2 = arr.map{if $0 == nil {return NSNull()} else {return $0!}} // compile error
            // let arr2 = arr.map{s -> AnyObject in if s == nil {return NSNull()} else {return s!}}
            let arr2 : [Any] =
                arr.map {if $0 != nil {return $0!} else {return NSNull()}} // * NB change to [Any]
            _ = arr2
        }
        
        do {
            // the API is fixed!
            let arr = UIFont.familyNames.map {
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
            // ooooookay, in Xcode 8 seed 6, the matter is settled — it's Any
            let s = "howdy" as NSObject
            let s2 = "howdy" as AnyObject
            let s3 = s as! String
            let s4 = s2 as! String
            print(s3, s4)
            let arr = [Dog()]
            let nsarr = arr as NSArray
            // there is no problem even if it is NOT an NSObject, so what's the big deal?
            print(nsarr.object(at:0))
            
            let arr2 : [Any] = ["howdy", Dog()]
            let nsarr2 = arr2 as NSArray
            print(nsarr2)
            
        }
        
        do {
            let arr : [Any] = [1,2,3]
            let arr2 = arr as NSArray // no downcast; they are equivalent
            let arr3 = arr as! [Int] // downcast needed
            let _ = (arr, arr2, arr3)
        }
        
        do {
            // showing one common way to lose element typing
            let arr = [1,2,3]
            let fm = FileManager.default
            let f = fm.temporaryDirectory.appendingPathComponent("test.plist")
            (arr as NSArray).write(to: f, atomically: true)
            let arr2 = NSArray(contentsOf: f)
            print(type(of:arr2))
        }
        
        do {
            class Cat {}
            let cat1 = Cat()
            let cat2 = Cat()
            let ok = cat1 === cat2 // but `==` no longer compiles
            _ = ok
        }
        
        do {
            // using the array extension shown at the top
            let arr = [1,2,3,4,5]
            let chunked = arr.chunked(by: 2)
            print(chunked) // [[1, 2], [3, 4], [5]]
        }

    }

}

