

import UIKit

class Dog : NSObject {
    var name : String
    init(_ name:String) {self.name = name}
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        let arr = ["hey"] as NSArray
        let ix = arr.indexOfObject("ho")
        if ix == NSNotFound {
            println("it wasn't found")
        }

        let s = "howdy"
        let r = s.rangeOfString("ha") // nil; an Optional wrapping a Swift Range
        if r == nil {
            println("it wasn't found")
        }

        let s2 = "howdy" as NSString
        let r2 = s2.rangeOfString("ha") // an NSRange
        if r2.location == NSNotFound {
            println("it wasn't found")
        }

        if true {
            let s2 = s.capitalizedString
        }
        
        if true {
            // let s2 = s.substringToIndex(4) // compile error
            let s2 = s.substringToIndex(advance(s.startIndex,4))
            let ss2 = (s as NSString).substringToIndex(4)
        }
        
        if true {
            let s = "hello"
            let ms = NSMutableString(string:s)
            ms.deleteCharactersInRange(NSMakeRange(ms.length-1,1))
            let s2 = (ms as String) + "ion" // now s2 is a Swift String
        }
        
        if true {
            var s = NSMutableString(string:"hello world, go to hell")
            let r = NSRegularExpression(
                pattern: "\\bhell\\b",
                options: .CaseInsensitive, error: nil)!
            r.replaceMatchesInString(
                s, options: nil, range: NSMakeRange(0,s.length),
                withTemplate: "heaven")
            println(s)
        }
        
        if true {
            let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let comp = NSDateComponents()
            comp.year = 2015
            comp.month = 8
            comp.day = 10
            comp.hour = 15
            let d = greg.dateFromComponents(comp) // Optional wrapping NSDate
            
            println(d!)
            println(d!.descriptionWithLocale(NSLocale.currentLocale()))

        }
        
        if true {
            let d = NSDate() // or whatever
            let comp = NSDateComponents()
            comp.month = 1
            let greg = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
            let d2 = greg.dateByAddingComponents(comp, toDate:d, options:nil)
        }
        
        if true {
            let df = NSDateFormatter()
            let format = NSDateFormatter.dateFormatFromTemplate(
                "dMMMMyyyyhmmaz", options:0, locale:NSLocale.currentLocale())
            df.dateFormat = format
            let s = df.stringFromDate(NSDate()) // just now
            println(s)
        }
        
        if true {
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setInteger(0, forKey: "Score")
            ud.setObject(0, forKey: "Score")
            let n = 0 as NSNumber
            let n2 = NSNumber(float:0)
            
            let dec1 = NSDecimalNumber(float: 4.0)
            let dec2 = NSDecimalNumber(float: 5.0)
            let sum = dec1.decimalNumberByAdding(dec2) // 9.0
        }
        
        if true {
            let ud = NSUserDefaults.standardUserDefaults()
            let c = UIColor.blueColor()
            let cdata = NSKeyedArchiver.archivedDataWithRootObject(c)
            ud.setObject(cdata, forKey: "myColor")
        }
        
        if true {
            let n1 = NSNumber(integer:1)
            let n2 = NSNumber(integer:2)
            let n3 = NSNumber(integer:3)
            let ok = n2 == 2 // true
            let ok2 = n2 == NSNumber(integer:2) // true
            let ix = find([n1,n2,n3], 2) // Optional wrapping 1
            
            // let ok3 = n1 < n2 // compile error
            let ok3 = n1.compare(n2) == .OrderedAscending // true

        }
        
        if true {
            let d1 = Dog("Fido")
            let d2 = Dog("Fido")
            let ok = d1 == d2 // false
        }
        
        if true {
            var arr = ["zero", "one", "two", "three", "four", "five"]
            arr.extend(["six", "seven", "eight", "nine", "ten"])
            let ixs = NSMutableIndexSet()
            ixs.addIndexesInRange(NSRange(1...4))
            ixs.addIndexesInRange(NSRange(8...10))
            let arr2 = (arr as NSArray).objectsAtIndexes(ixs)
        }
        
        if true {
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

        }
        
    }


}

