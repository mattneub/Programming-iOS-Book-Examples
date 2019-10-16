

import UIKit

class Dog : NSObject {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
}

class Dog2 : NSObject { // a dog equatable and hashable on its name
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    override func isEqual(_ object: Any?) -> Bool {
        if let otherdog = object as? Dog2 {
            return otherdog.name == self.name && otherdog.license == self.license
        }
        return false
    }
    override var hash: Int {
        var h = Hasher()
        h.combine(self.name)
        h.combine(self.license)
        return h.finalize()
    }
}



class ViewController: UIViewController {
    
    let oldButtonCenter = CGPoint.zero
    let button = UIButton(type:.system)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // let obj = NSObject().copy(with:nil) // compile error
            let s = "hello".copy()
            _ = s
            let s2 = ("hello" as NSString).copy(with: nil)
            _ = s2
        }

        do {
            let arr = ["hey"] as NSArray
            let ix = arr.index(of:"ho") // NSArray method, not Swift
            if ix == NSNotFound {
                print("it wasn't found")
            }
        }
        
        do {
            // the following now works!
            let rr = NSRange(1...3)
            let r = NSRange(Range(1...3))
            print(r)
            debugPrint(r) // that didn't help
            print(NSStringFromRange(r))
            let r2 = Range(r) // *
            print(r2 as Any)
            // let r3 = Range(r)
            // print(r3)
            print(rr)
        }

        do {
            let s = "hello"
            let r = s.range(of:"ha") // nil; an Optional wrapping a Swift Range
            if r == nil {
                print("it wasn't found")
            }
        }

        do {
            let s = "hello" as NSString
            let r = s.range(of:"ha") // an NSRange
            if r.location == NSNotFound {
                print("it wasn't found")
            }
        }
        
        do {
            let s = "Hello"
            let r = (s as NSString).range(of: "ell")
            let mas = NSMutableAttributedString(string:s)
            mas.addAttributes([.foregroundColor:UIColor.red], range: r)
        }

        do {
            let s = "hello"
            let s2 = s.capitalized // -[NSString capitalizedString]
            _ = s2
        }
        
        do {
            let s = "hello"
            let ix = "hello".startIndex
            // let s2a = s.substring(to:4) // compile error
            // let s2 = s.substring(to:s.index(s.startIndex, offsetBy:4)) // deprecated
            let ss2 = (s as NSString).substring(to:4)
            let ss3 = s.prefix(4)
            print(ss2, ss3)
            _ = ix
        }
        
        do {
            let s = "MyFile"
            let s2 = (s as NSString).appendingPathExtension("txt")
            // let s3 = s.appendingPathExtension("txt") // compile error

            print(s2 as Any)
        }
        
        do {
            let s = "hello"
            let ms = NSMutableString(string:s)
            ms.deleteCharacters(in: NSRange(location:ms.length-1,length:1))
            let s2 = (ms as String) + "ion" // now s2 is a Swift String
            print(s2)
        }
        
        do {
            var s = "hello world, go to hell"
            let r = try! NSRegularExpression(
                pattern: "\\bhell\\b",
                options: .caseInsensitive)
            s = r.stringByReplacingMatches(
                in: s,
                range: NSRange(s.startIndex..<s.endIndex, in:s),
                withTemplate: "heaven")
            // I loooove being able to omit the options: parameter!
            print(s)
        }
        
        do {
            let sc = Scanner()
            _ = sc
        }
        
        do {
            let greg = Calendar(identifier:.gregorian)
            let comp = DateComponents(calendar: greg, year: 2018, month: 8, day: 10, hour: 15)
            let d = comp.date // Optional wrapping Date
            if let d = d {
                print(d)
                print(d.description(with:Locale.current))
                let d2 = d + 4
                _ = d2
            }
            
        }
        
        do {
            let d = Date() // or whatever
            let comp = DateComponents(month:1)
            let greg = Calendar(identifier:.gregorian)
            let d2 = greg.date(byAdding: comp, to:d) // Optional wrapping Date
            print("one month from now:", d2 as Any)
        }
        
        do {
            let greg = Calendar(identifier:.gregorian)
            let d1 = DateComponents(calendar: greg,
                                    year: 2018, month: 1, day: 1, hour: 0).date!
            let d2 = DateComponents(calendar: greg,
                                    year: 2018, month: 8, day: 10, hour: 15).date!
            let di = DateInterval(start: d1, end: d2)
            if di.contains(Date()) { // are we currently between those two dates?
                print("yep")
            }
        }
        
        do {
            let df = DateFormatter()
            df.dateFormat = "M/d/y"
            let s = df.string(from: Date()) // 7/31/2018
            print(s)
        }
        
        do {
            let df = DateFormatter()
            let format = DateFormatter.dateFormat(
                fromTemplate:"dMMMMyyyyhmmaz", options:0,
                locale:Locale.current)
            df.dateFormat = format
            let s = df.string(from: Date()) // just now
            print(s)
        }
        
        do {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "M/d/y"
            let d = df.date(from: "31/7/2018")
            print(d as Any)
        }

        
        do {
            UserDefaults.standard.set(1, forKey: "Score")
            let n = UserDefaults.standard.value(forKey:"Score")
            // prove that we crossed the bridge
            print(type(of:n!)) // __NSCFNumber
            let i = n as! Int
            let ii = n as! Double
            let _ = (i,ii)
            
            do {
                // wow - unable to call setObject:forKey: while supplying a number!
                // UserDefaults.standard.set(object: 0, forKey: "Score")
                let n = 1 as NSNumber
                // similarly, unable to call NSNumber initWithFloat:
                // instead we just supply a float and let it disambiguate
                let i : UInt8 = 1
                let n2 = i as NSNumber // not bridged // * okay, now bridged!
                let n3 = NSNumber(value:i)
                _ = (n3, n2,n)
            }
            
            do {
                // I regard these as bugs
                // fixed!
                let n = UInt32(0) as NSNumber // compile error // not any more
                let i = n as! UInt32 // "always fails" // not any more
                _ = i
            }
            
            do {
                _ = true as NSNumber
            }
            
            let dec1 = 4.0 as NSDecimalNumber
            let dec2 = 5.0 as NSDecimalNumber
            let sum = dec1.adding(dec2) // 9.0
            print(sum)
            _ = n
            _ = sum
        }
        
        do {
            // perhaps the first example is more convincing if we use a variable
            let ud = UserDefaults.standard
            let i = 0
            ud.set(i, forKey: "Score")
            // ud.setObject(i, forKey: "Score")
            
        }
        
        
        do {
            /*
            let goal = CGPoint.zero // dummy
            let ba = CABasicAnimation(keyPath:#keyPath(CALayer.position))
            ba.duration = 10
            ba.fromValue = NSValue(cgPoint:self.oldButtonCenter)
            ba.toValue = NSValue(cgPoint:goal)
            self.button.layer.add(ba, forKey:nil)
 */
            // but that is no longer needed! now we can say:
            let goal = CGPoint.zero // dummy
            let ba = CABasicAnimation(keyPath:#keyPath(CALayer.position))
            ba.duration = 10
            ba.fromValue = self.oldButtonCenter
            ba.toValue = goal
            self.button.layer.add(ba, forKey:nil)
            // we have been wrapped in NSValue as we crossed the bridge:
            print(type(of:ba.fromValue!), type(of:ba.toValue!))

        }
        
        // this is no longer needed either
        do {
            let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.position)) // dummy
            let (oldP,p1,p2,newP) = (CGPoint.zero,CGPoint.zero,CGPoint.zero,CGPoint.zero) // dummy
            anim.values = [oldP,p1,p2,newP].map {NSValue(cgPoint:$0)}
        }
        
        do {
            let ud = UserDefaults.standard
            let c = UIColor.blue
            let cdata = try! NSKeyedArchiver.archivedData(withRootObject: c, requiringSecureCoding: true)
            ud.set(cdata, forKey: "myColor")
        }
        
        do {
            let ud = UserDefaults.standard
            if let cdata = ud.object(forKey: "myColor") as? Data {
                let c = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: cdata)
                // c is an Optional wrapping a UIColor
                print(c as Any)
            }
        }
                
        do {
            let m1 = Measurement(value:5, unit: UnitLength.miles)
            let m2 = Measurement(value:6, unit: UnitLength.kilometers)
            let total = m1 + m2
            print(total)
            let totalFeet = total.converted(to: .feet).value // 46084.9737532808
            print(totalFeet)
            let mf = MeasurementFormatter()
            let s = mf.string(from:total) // "8.728 mi"
            print(s)
        }
        
        do {
            let n1 = 1 as NSNumber
            let n2 = 2 as NSNumber
            let n3 = 3 as NSNumber
            let ok = n2 == 2 // true
            let ok2 = n2 == 2 as NSNumber // true
            let ix = [n1,n2,n3].firstIndex(of:2) // Optional wrapping 1
            
            // let ok3 = n1 < n2 // compile error
            let ok4 = n1.compare(n2) == .orderedAscending // true
            print(ok)
            print(ok2)
            print(ix as Any)
            print(ok4)
        }
        
        do {
            let d1 = Dog(name:"Fido", license:1)
            let d2 = Dog(name:"Fido", license:1)
            let ok = d1 == d2 // false
            print(ok)
        }
        
        do {
            let d1 = Dog2(name:"Fido", license:1)
            let d2 = Dog2(name:"Fido", license:1)
            let ok = d1 == d2 // true
            print(ok)
        }
        
        do {
            var set1 = Set<Dog>()
            set1.insert(Dog(name:"Fido", license:1))
            set1.insert(Dog(name:"Fido", license:1))
            print(set1.count) // 2, because custom equality/hashability is not being used
            
            var set2 = Set<Dog2>()
            set2.insert(Dog2(name:"Fido", license:1))
            set2.insert(Dog2(name:"Fido", license:1))
            print(set2.count) // 1, with custom equality/hashability
            
        }
        
        do {
            let arr = ["zero", "one", "two", "three", "four", "five",
                       "six", "seven", "eight", "nine", "ten"]
            var ixs = IndexSet()
            ixs.insert(integersIn: Range(1...4))
            ixs.insert(integersIn: Range(8...10))
            let arr2 = (arr as NSArray).objects(at:ixs)
            print(arr2)
        }
                
        do {
            let marr = NSMutableArray()
            marr.add(1) // an NSNumber
            marr.add(1) // an NSNumber
            print(type(of:marr[0]))
            // this now works and no longer warns
            let arr2 = marr as! [Int] // warns, but it _looks_ like it succeeds...
            print(arr2)
            print(type(of:arr2[0]))

            let pep = ["Manny", "Moe", "Jack"] as NSArray
                        
            let ems = pep.objects(
                at: pep.indexesOfObjects { (obj, idx, stop) -> Bool in
                    return (obj as! NSString).range(
                        of: "m", options:.caseInsensitive
                        ).location == 0
                }
            ) // ["Manny", "Moe"]
            print(ems)
            
            let arr3 = marr.copy()
            _ = arr3
        }
        
        do {
            let ms = NSMutableSet(set:[1,2,3])
            // ... do stuff to ms ...
            let s = ms as! Set<Int>
            print(s)
            
            let cs = NSCountedSet(set:[1,2,3])
            cs.add(1)
            print(cs)
            print(cs.count(for: 1))
            let s2 = cs as! Set<Int>
            print(s2)
            let arr = cs.allObjects as! Array<Int>
            print(arr)
            // does not magically add "1" twice just because its count is 2
        }
        
        do {
            let s = "howdy"
            UserDefaults.standard.set(s, forKey:"ha")
            let any = UserDefaults.standard.object(forKey:"ha")
            print(type(of:any!))

        }
        
    }


}

