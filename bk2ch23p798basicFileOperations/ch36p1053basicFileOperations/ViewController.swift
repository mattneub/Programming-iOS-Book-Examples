

import UIKit

class ViewController: UIViewController {
    let query = NSMetadataQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // failed experiment; can't use NSMetadataQuery except in the iCloud folder
//        self.query.predicate = NSPredicate(format:"%K ENDSWITH '.txt'", NSMetadataItemFSNameKey)
//        self.query.startQuery()
    }

    @IBAction func doButton1 (_ sender:AnyObject!) {
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print(docs)
    }
    
    @IBAction func doButton2 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton3 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let suppurl = try fm.urlForDirectory(.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(suppurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton4 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let myfolder = docsurl.appendingPathComponent("MyFolder")
            
            try fm.createDirectory(at:myfolder, withIntermediateDirectories: true, attributes: nil)

            // if we get here, myfolder exists
            // let's put a couple of files into it
            try "howdy".write(to: myfolder.appendingPathComponent("file1.txt"), atomically: true, encoding: NSUTF8StringEncoding)
            try "greetings".write(to: myfolder.appendingPathComponent("file2.txt"), atomically: true, encoding: NSUTF8StringEncoding)
            print("ok")
        } catch {
            print(error)
        }
    }

    @IBAction func doButton5 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let arr = try fm.contentsOfDirectory(at:docsurl, includingPropertiesForKeys: nil, options: [])
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
    
    @IBAction func doButton7 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at:docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
            for case let f as NSURL in dir where f.pathExtension == "txt" {
                print(f.lastPathComponent!)
            }
        } catch {
            print(error)
        }
    }
    
    let which = 1
    
    @IBAction func doButton8 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moi = Person(firstName: "Matt", lastName: "Neuburg")
            let moidata = NSKeyedArchiver.archivedData(withRootObject: moi)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
                moidata.write(to: moifile, atomically: true)
                try moifile.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.writingIntent(with:moifile, options: [])
                fc.coordinate(with:[intent], queue: NSOperationQueue.main()) {
                    (err:NSError?) in
                    // compiler gets confused if a one-liner returns a BOOL result
                    moidata.write(to: intent.url, atomically: true)
                }
            default:break
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func doButton9 (_ sender:AnyObject!) {
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
                let persondata = NSData(contentsOf: moifile)!
                let person = NSKeyedUnarchiver.unarchiveObject(with: persondata) as! Person
                print(person)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.readingIntent(with: moifile, options: [])
                fc.coordinate(with: [intent], queue: NSOperationQueue.main()) {
                    (err:NSError?) in
                    let persondata = NSData(contentsOf: intent.url)!
                    let person = NSKeyedUnarchiver.unarchiveObject(with: persondata) as! Person
                    print(person)
                }
            default:break
            }
        } catch {
            print(error)
        }
    }
    
    

}
