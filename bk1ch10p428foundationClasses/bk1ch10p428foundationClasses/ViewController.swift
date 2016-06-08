

import UIKit

class Dog : NSObject {
    var name : String
    init(_ name:String) {self.name = name}
}


class ViewController: UIViewController {
    
    let oldButtonCenter = CGPoint.zero
    let button = UIButton(type:.system)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // let obj = NSObject().copy(with:nil) // compile error
            let s = "hello".copy(with:nil)
            _ = s
        }

        do {
            let arr = ["hey"] as NSArray
            let ix = arr.index(of:"ho")
            if ix == NSNotFound {
                print("it wasn't found")
            }
        }
        
        do {
            let r = NSRange(Range<Int>(1...3))
            print(r)
            let r2 = r.toRange()
            print(r2)
            // let r3 = Range(r)
            // print(r3)
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
            let s = "hello"
            let s2 = s.capitalized // -[NSString capitalizedString]
            _ = s2
        }
        
        do {
            let s = "hello"
            let ix = "hello".startIndex
            // let s2a = s.substringToIndex(4) // compile error
            let s2 = s.substring(to:s.index(s.startIndex, offsetBy:4))
            let ss2 = (s as NSString).substring(to:4)
            _ = s2
            _ = ss2
            _ = ix
        }
        
        do {
            let s = "MyFile"
            let s2 = (s as NSString).appendingPathExtension("txt")
            // let s3 = s.stringByAppendingPathExtension("txt") // compile error

            print(s2)
        }
        
        do {
            let s = "hello"
            let ms = NSMutableString(string:s)
            ms.deleteCharacters(in: NSRange(location:ms.length-1,length:1))
            let s2 = (ms as String) + "ion" // now s2 is a Swift String
            print(s2)
        }
        
        do {
            let s = NSMutableString(string:"hello world, go to hell")
            let r = try! NSRegularExpression(
                pattern: "\\bhell\\b",
                options: .caseInsensitive)
            r.replaceMatches(
                in: s, range: NSRange(location:0, length:s.length),
                withTemplate: "heaven")
            // I loooove being able to omit the options: parameter!
            print(s)
        }
        
        do {
            let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let comp = NSDateComponents()
            comp.year = 2016
            comp.month = 8
            comp.day = 10
            comp.hour = 15
            let d = greg.date(from: comp) // Optional wrapping NSDate
            if let d = d {
                print(d)
                print(d.description(with:NSLocale.current()))
            }

        }
        
        do {
            let d = NSDate() // or whatever
            let comp = NSDateComponents()
            comp.month = 1
            let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let d2 = greg.date(byAdding: comp, to:d)
            _ = d2
        }
        
        do {
            let df = NSDateFormatter()
            let format = NSDateFormatter.dateFormat(
                fromTemplate:"dMMMMyyyyhmmaz", options:0,
                locale:NSLocale.current())
            df.dateFormat = format
            let s = df.string(from: NSDate()) // just now
            print(s)
        }
        
        do {
            NSUserDefaults.standard().set(1, forKey: "Score")
            // wow - unable to call setObject:forKey: while supplying a number!
            // ud.set(object: 0, forKey: "Score")
            let n = 1 as NSNumber
            // similarly, unable to call NSNumber initWithFloat:
            // instead we just supply a float and let it disambiguate
            let i : UInt8 = 1
            // let n2 = i as NSNumber // not bridged
            let n2 = NSNumber(value:i)
            
            do {
                // I regard these as bugs
                // let n = UInt32(0) as NSNumber // compile error
                // let i = n as! UInt32 // "always fails"
            }
            
            let dec1 = NSDecimalNumber(value: 4.0)
            let dec2 = NSDecimalNumber(value: 5.0)
            let sum = dec1.adding(dec2) // 9.0
            _ = n
            _ = n2
            _ = sum
        }
        
        do {
            // perhaps the first example is more convincing if we use a variable
            let ud = NSUserDefaults.standard()
            let i = 0
            ud.set(i, forKey: "Score")
            // ud.setObject(i, forKey: "Score")
            
        }
        
        
        do {
            let goal = CGPoint.zero // dummy
            let ba = CABasicAnimation(keyPath:"position")
            ba.duration = 10
            ba.fromValue = NSValue(cgPoint:self.oldButtonCenter)
            ba.toValue = NSValue(cgPoint:goal)
            self.button.layer.add(ba, forKey:nil)
        }
        
        do {
            let anim = CAKeyframeAnimation(keyPath:"position") // dummy
            let (oldP,p1,p2,newP) = (CGPoint.zero,CGPoint.zero,CGPoint.zero,CGPoint.zero) // dummy
            anim.values = [oldP,p1,p2,newP].map {NSValue(cgPoint:$0)}
        }
        
        do {
            let ud = NSUserDefaults.standard()
            let c = UIColor.blue()
            let cdata = NSKeyedArchiver.archivedData(withRootObject:c)
            ud.set(cdata, forKey: "myColor")
        }
        
        do {
            let n1 = NSNumber(value:1)
            let n2 = NSNumber(value:2)
            let n3 = NSNumber(value:3)
            let ok = n2 == 2 // true
            let ok2 = n2 == NSNumber(value:2) // true
            let ix = [n1,n2,n3].index(of:2) // Optional wrapping 1
            
            // let ok3 = n1 < n2 // compile error
            let ok4 = n1.compare(n2) == .orderedAscending // true
            print(ok)
            print(ok2)
            print(ix)
            print(ok4)
        }
        
        do {
            let d1 = Dog("Fido")
            let d2 = Dog("Fido")
            let ok = d1 == d2 // false
            print(ok)
        }
        
        do {
            let arr = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
            let ixs = NSMutableIndexSet()
            ixs.add(in: NSRange(1..<5))
            ixs.add(in: NSRange(8..<11))
            let arr2 = (arr as NSArray).objects(at:ixs)
            print(arr2)
        }
                
        do {
            let marr = NSMutableArray()
            marr.add(1) // an NSNumber
            marr.add(2) // an NSNumber
            let arr = marr as NSArray as! [Int]

            let pep = ["Manny", "Moe", "Jack"] as NSArray
            
            // filed a bug: "ambiguous" without the []
            
            let ems = pep.objects(
                at: pep.indexesOfObjects([]) {
                    (obj, idx, stop) -> Bool in
                    return (obj as! NSString).range(
                        of: "m", options:.caseInsensitiveSearch
                        ).location == 0
                }
            ) // ["Manny", "Moe"]
            _ = arr
            print(ems)
        }
        
        do {
            // looking to see whether struct Data is implemented yet!
            // https://github.com/apple/swift-evolution/blob/master/proposals/0069-swift-mutability-for-foundation.md
            // var d = Data()
//            class MyData : NSMutableData { }
//            
//            func myData() -> Data {
//                return MyData() as Data
//            }

        }
        
    }


}

