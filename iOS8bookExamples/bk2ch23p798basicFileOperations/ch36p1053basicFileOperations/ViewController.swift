

import UIKit

class ViewController: UIViewController {
    let query = NSMetadataQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // failed experiment; can't use NSMetadataQuery except in the iCloud folder
//        self.query.predicate = NSPredicate(format:"%K ENDSWITH '.txt'", NSMetadataItemFSNameKey)
//        self.query.startQuery()
    }

    @IBAction func doButton1 (sender:AnyObject!) {
        let docs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as! String
        println(docs)
    }
    
    @IBAction func doButton2 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        if let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err) {
            println(docsurl)
        } else {
            println(err)
        }
    }

    @IBAction func doButton3 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        if let suppurl = fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err) {
            println(suppurl)
        } else {
            println(err)
        }
    }

    @IBAction func doButton4 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        // error-checking omitted
        let myfolder = docsurl.URLByAppendingPathComponent("MyFolder")
        var ok = fm.createDirectoryAtURL(myfolder, withIntermediateDirectories: true, attributes: nil, error: &err)
        if !ok {
            println(err)
            return
        }
        // if we get here, myfolder exists
        // let's put a couple of files into it
        ok = "howdy".writeToURL(myfolder.URLByAppendingPathComponent("file1.txt"), atomically: true, encoding: NSUTF8StringEncoding, error: &err)
        if !ok {
            println(err)
            return
        }
        ok = "greetings".writeToURL(myfolder.URLByAppendingPathComponent("file2.txt"), atomically: true, encoding: NSUTF8StringEncoding, error: &err)
        if !ok {
            println(err)
            return
        }
        println("ok")
    }

    @IBAction func doButton5 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        let arr = fm.contentsOfDirectoryAtURL(docsurl, includingPropertiesForKeys: nil, options: nil, error: &err)
        if arr == nil {
            println(err)
            return
        }
        (arr as! [NSURL]).map{$0.lastPathComponent!}.map(println)
        // ======
//        self.query.enumerateResultsUsingBlock {
//            obj, ix, stop in
//            println(obj)
//        }
    }
    
    @IBAction func doButton7 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        let dir = fm.enumeratorAtURL(docsurl, includingPropertiesForKeys: nil, options: nil, errorHandler: nil)!
        // this is what you do when an Objective-C enumerable doesn't conform to Swift's SequenceType
        while let f = dir.nextObject() as? NSURL {
            if f.pathExtension == "txt" {
                println(f.lastPathComponent!)
            }
        }
    }
    
    let which = 1
    
    @IBAction func doButton8 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        let moi = Person(firstName: "Matt", lastName: "Neuburg")
        let moidata = NSKeyedArchiver.archivedDataWithRootObject(moi)
        let moifile = docsurl.URLByAppendingPathComponent("moi.txt")
        switch which {
        case 1:
            moidata.writeToURL(moifile, atomically: true)
            // moifile.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey, error: &err)
        case 2:
            // ==== the NSFileCoordinator way
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.writingIntentWithURL(moifile, options: nil)
            fc.coordinateAccessWithIntents([intent], queue: NSOperationQueue.mainQueue()) {
                (err:NSError!) in
                // compiler gets confused if a one-liner returns a BOOL result
                let ok = moidata.writeToURL(intent.URL, atomically: true)
            }
        default:break
        }
    }
    
    @IBAction func doButton9 (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)!
        let moifile = docsurl.URLByAppendingPathComponent("moi.txt")
        switch which {
        case 1:
            let persondata = NSData(contentsOfURL: moifile)!
            let person = NSKeyedUnarchiver.unarchiveObjectWithData(persondata) as! Person
            println(person)
        case 2:
            // ==== the NSFileCoordinator way
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.readingIntentWithURL(moifile, options: nil)
            fc.coordinateAccessWithIntents([intent], queue: NSOperationQueue.mainQueue()) {
                (err:NSError!) in
                let persondata = NSData(contentsOfURL: intent.URL)!
                let person = NSKeyedUnarchiver.unarchiveObjectWithData(persondata) as! Person
                println(person)
            }
        default:break
        }
    }
    
    

}
