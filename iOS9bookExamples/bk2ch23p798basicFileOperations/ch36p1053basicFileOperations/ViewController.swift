

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
        let docs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
        print(docs)
    }
    
    @IBAction func doButton2 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            print(docsurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton3 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let suppurl = try fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
            print(suppurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton4 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let myfolder = docsurl.URLByAppendingPathComponent("MyFolder")
            
            try fm.createDirectoryAtURL(myfolder, withIntermediateDirectories: true, attributes: nil)

            // if we get here, myfolder exists
            // let's put a couple of files into it
            try "howdy".writeToURL(myfolder.URLByAppendingPathComponent("file1.txt"), atomically: true, encoding: NSUTF8StringEncoding)
            try "greetings".writeToURL(myfolder.URLByAppendingPathComponent("file2.txt"), atomically: true, encoding: NSUTF8StringEncoding)
            print("ok")
        } catch {
            print(error)
        }
    }

    @IBAction func doButton5 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let arr = try fm.contentsOfDirectoryAtURL(docsurl, includingPropertiesForKeys: nil, options: [])
            arr.forEach{print($0.lastPathComponent!)}
            // ======
    //        self.query.enumerateResultsUsingBlock {
    //            obj, ix, stop in
    //            print(obj)
    //        }
        } catch {
            print(error)
        }
    }
    
    @IBAction func doButton7 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let dir = fm.enumeratorAtURL(docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
            for case let f as NSURL in dir where f.pathExtension == "txt" {
                print(f.lastPathComponent!)
            }
        } catch {
            print(error)
        }
    }
    
    let which = 1
    
    @IBAction func doButton8 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let moi = Person(firstName: "Matt", lastName: "Neuburg")
            let moidata = NSKeyedArchiver.archivedDataWithRootObject(moi)
            let moifile = docsurl.URLByAppendingPathComponent("moi.txt")
            switch which {
            case 1:
                moidata.writeToURL(moifile, atomically: true)
                try moifile.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.writingIntentWithURL(moifile, options: [])
                fc.coordinateAccessWithIntents([intent], queue: NSOperationQueue.mainQueue()) {
                    (err:NSError?) in
                    // compiler gets confused if a one-liner returns a BOOL result
                    moidata.writeToURL(intent.URL, atomically: true)
                }
            default:break
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func doButton9 (sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let moifile = docsurl.URLByAppendingPathComponent("moi.txt")
            switch which {
            case 1:
                let persondata = NSData(contentsOfURL: moifile)!
                let person = NSKeyedUnarchiver.unarchiveObjectWithData(persondata) as! Person
                print(person)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.readingIntentWithURL(moifile, options: [])
                fc.coordinateAccessWithIntents([intent], queue: NSOperationQueue.mainQueue()) {
                    (err:NSError?) in
                    let persondata = NSData(contentsOfURL: intent.URL)!
                    let person = NSKeyedUnarchiver.unarchiveObjectWithData(persondata) as! Person
                    print(person)
                }
            default:break
            }
        } catch {
            print(error)
        }
    }
    
    

}
