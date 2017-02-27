

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


/* From my answer at http://stackoverflow.com/a/42460276/341994
 The use case is a collection of delegates to which we need weak references.
 This example exercises NSHashTable to show
 how to use it to solve the problem.
 For completeness, I also exercise NSPointerArray, but NSHashTable is better
 for this use case.
 */

// Not in book, but I do mention these classes in a note


protocol SomeDelegate: class {
    func someFunction()
}

class SomeClass : NSObject, SomeDelegate {
    func someFunction() { print("some function!") }
}


class ViewController: UIViewController {
    
    let list = NSHashTable<AnyObject>.weakObjects()
    let parr = NSPointerArray.weakObjects()
    
    // accessors for NSHashTable
    // we need these because you cannot store a SomeDelegate, qua protocol,
    // in a hash table
    
    func addToList(_ obj:SomeDelegate) {
        list.add(obj)
    }
    func retrieveFromList(_ obj:SomeDelegate) -> SomeDelegate? {
        if let result = list.member(obj) as? SomeDelegate {
            return result
        }
        return nil
    }
    func retrieveAllFromList() -> [SomeDelegate] {
        return list.allObjects as! [SomeDelegate]
    }
    
    // and here's the test
    
    func test() {
        let c = SomeClass() // adopter of SomeDelegate
        self.addToList(c)
        if let cc = self.retrieveFromList(c) {
            cc.someFunction() // calls
        }
        print(self.retrieveAllFromList()) // it's in there
        delay(1) {
            print(self.retrieveAllFromList()) // empty
        }
    }
    
    // accessors for NSPointerArray
    // the problem here is that object-to-pointer and pointer-to-object are verbose
    // code based on http://stackoverflow.com/a/33310021/341994
    
    func addToArray(_ obj:SomeDelegate) {
        let ptr = Unmanaged<AnyObject>.passUnretained(obj).toOpaque()
        self.parr.addPointer(ptr)
    }
    func fetchFromArray(at ix:Int) -> SomeDelegate? {
        if let ptr = self.parr.pointer(at:ix) {
            let obj = Unmanaged<AnyObject>.fromOpaque(ptr).takeUnretainedValue()
            if let del = obj as? SomeDelegate {
                return del
            }
        }
        return nil
    }
    
    // and here's the test
    
    func test2() {
        let c = SomeClass()
        self.addToArray(c)
        for ix in 0..<self.parr.count {
            if let del = self.fetchFromArray(at:ix) {
                del.someFunction() // calls
            }
        }
        delay(1) {
            // uncomment these three lines to force immediate compaction
            // see http://stackoverflow.com/a/40274426/341994
            // the reason is that `nil` can stay in the array
            // but there is no need for compaction because `if let` guards us
//            self.parr.addPointer(nil)
//            self.parr.compact()
//            let ct = self.parr.count
            print(self.parr.count)
            for ix in 0..<self.parr.count {
                if let del = self.fetchFromArray(at:ix) {
                    del.someFunction() // nothing
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.test()
        delay(5) {
            self.test2()
        }
    }


}

