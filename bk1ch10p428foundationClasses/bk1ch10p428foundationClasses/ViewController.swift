

import UIKit

class Dog : NSObject {
    var name : String
    init(_ name:String) {self.name = name}
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let arr = ["hey"] as NSArray
            let ix = arr.indexOfObject("ho")
            if ix == NSNotFound {
                print("it wasn't found")
            }
        }
        
        do {
            let r = NSRange(1...3)
            print(r)
            let r2 = r.toRange()
            print(r2)
            // let r3 = Range(r)
            // print(r3)
        }

        do {
            let s = "hello"
            let r = s.rangeOfString("ha") // nil; an Optional wrapping a Swift Range
            if r == nil {
                print("it wasn't found")
            }
        }

        do {
            let s = "hello" as NSString
            let r = s.rangeOfString("ha") // an NSRange
            if r.location == NSNotFound {
                print("it wasn't found")
            }
        }

        do {
            let s = "hello"
            let s2 = s.capitalizedString // -[NSString capitalizedString]
            _ = s2
        }
        
        do {
            let s = "hello"
            // let s2 = s.substringToIndex(4) // compile error
            let s2 = s.substringToIndex(s.startIndex.advancedBy(4))
            let ss2 = (s as NSString).substringToIndex(4)
            _ = s2
            _ = ss2
        }
        
        do {
            let s = "MyFile"
            let s2 = (s as NSString).stringByAppendingPathExtension("txt")
            // let s3 = s.stringByAppendingPathExtension("txt") // compile error

            print(s2)
        }
        
        do {
            let s = "hello"
            let ms = NSMutableString(string:s)
            ms.deleteCharactersInRange(NSMakeRange(ms.length-1,1))
            let s2 = (ms as String) + "ion" // now s2 is a Swift String
            print(s2)
        }
        
        do {
            let s = NSMutableString(string:"hello world, go to hell")
            let r = try! NSRegularExpression(
                pattern: "\\bhell\\b",
                options: .CaseInsensitive)
            r.replaceMatchesInString(
                s, options: [], range: NSMakeRange(0,s.length),
                withTemplate: "heaven")
            print(s)
        }
        
        do {
            let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let comp = NSDateComponents()
            comp.year = 2016
            comp.month = 8
            comp.day = 10
            comp.hour = 15
            let d = greg.dateFromComponents(comp) // Optional wrapping NSDate
            if let d = d {
                print(d)
                print(d.descriptionWithLocale(NSLocale.currentLocale()))
            }

        }
        
        do {
            let d = NSDate() // or whatever
            let comp = NSDateComponents()
            comp.month = 1
            let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let d2 = greg.dateByAddingComponents(comp, toDate:d, options:[])
            _ = d2
        }
        
        do {
            let df = NSDateFormatter()
            let format = NSDateFormatter.dateFormatFromTemplate(
                "dMMMMyyyyhmmaz", options:0, locale:NSLocale.currentLocale())
            df.dateFormat = format
            let s = df.stringFromDate(NSDate()) // just now
            print(s)
        }
        
        do {
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setInteger(0, forKey: "Score")
            ud.setObject(0, forKey: "Score")
            let n = 0 as NSNumber
            let n2 = NSNumber(float:0)
            
            do {
                // I regard these as bugs
                // let n = UInt32(0) as NSNumber // compile error
                // let i = n as! UInt32 // "always fails"
            }
            
            let dec1 = NSDecimalNumber(float: 4.0)
            let dec2 = NSDecimalNumber(float: 5.0)
            let sum = dec1.decimalNumberByAdding(dec2) // 9.0
            _ = n
            _ = n2
            _ = sum
        }
        
        do {
            // perhaps the first example is more convincing if we use a variable
            let ud = NSUserDefaults.standardUserDefaults()
            let i = 0
            ud.setInteger(i, forKey: "Score")
            ud.setObject(i, forKey: "Score")
            
        }
        
        do {
            let ud = NSUserDefaults.standardUserDefaults()
            let c = UIColor.blueColor()
            let cdata = NSKeyedArchiver.archivedDataWithRootObject(c)
            ud.setObject(cdata, forKey: "myColor")
        }
        
        do {
            let n1 = NSNumber(integer:1)
            let n2 = NSNumber(integer:2)
            let n3 = NSNumber(integer:3)
            let ok = n2 == 2 // true
            let ok2 = n2 == NSNumber(integer:2) // true
            let ix = [n1,n2,n3].indexOf(2) // Optional wrapping 1
            
            // let ok3 = n1 < n2 // compile error
            let ok4 = n1.compare(n2) == .OrderedAscending // true
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
            ixs.addIndexesInRange(NSRange(1...4))
            ixs.addIndexesInRange(NSRange(8...10))
            let arr2 = (arr as NSArray).objectsAtIndexes(ixs)
            print(arr2)
        }
        
        do {
            let marr = NSMutableArray()
            marr.addObject(1) // an NSNumber
            marr.addObject(2) // an NSNumber
            let arr = marr as NSArray as! [Int]

            let pep = ["Manny", "Moe", "Jack"] as NSArray
            let ems = pep.objectsAtIndexes(
                pep.indexesOfObjectsPassingTest {
                    obj, idx, stop in
                    return (obj as! NSString).rangeOfString(
                        "m", options:.CaseInsensitiveSearch
                        ).location == 0
                }
            ) // ["Manny", "Moe"]
            _ = arr
            print(ems)
        }
        
    }


}

