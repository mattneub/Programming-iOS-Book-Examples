

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
            let fm = FileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton3 (_ sender:AnyObject!) {
        do {
            let fm = FileManager()
            let suppurl = try fm.urlForDirectory(.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(suppurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton4 (_ sender:AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let myfolder = try docsurl.appendingPathComponent("MyFolder")
            
            try fm.createDirectory(at:myfolder, withIntermediateDirectories: true, attributes: nil)

            // if we get here, myfolder exists
            // let's put a couple of files into it
            try "howdy".write(to: myfolder.appendingPathComponent("file1.txt"), atomically: true, encoding: .utf8)
            try "greetings".write(to: myfolder.appendingPathComponent("file2.txt"), atomically: true, encoding: .utf8)
            print("ok")
        } catch {
            print(error)
        }
    }

    @IBAction func doButton5 (_ sender:AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let arr = try fm.contentsOfDirectory(at:docsurl, includingPropertiesForKeys: nil)
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
            let fm = FileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at:docsurl, includingPropertiesForKeys: nil)!
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
            let fm = FileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moi = Person(firstName: "Matt", lastName: "Neuburg")
            let moidata = NSKeyedArchiver.archivedData(withRootObject: moi)
            var moifile = try docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
                try moidata.write(to: moifile, options: .dataWritingAtomic)
                var rv = URLResourceValues() // * new way, very nice
                rv.isExcludedFromBackup = true
                try moifile.setResourceValues(rv)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.writingIntent(with:moifile)
                fc.coordinate(with:[intent], queue: OperationQueue.main()) {
                    (err:NSError?) in
                    // compiler gets confused if a one-liner returns a BOOL result
                    do {
                        try moidata.write(to: intent.url, options: .dataWritingAtomic)
                    } catch {
                        print(error)
                    }
                }
            default:break
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func doButton9 (_ sender:AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moifile = try docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
                let persondata = try Data(contentsOf: moifile)
                let person = NSKeyedUnarchiver.unarchiveObject(with: persondata) as! Person
                print(person)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.readingIntent(with: moifile)
                fc.coordinate(with: [intent], queue: OperationQueue.main()) {
                    (err:NSError?) in
                    do {
                        let persondata = try Data(contentsOf: intent.url)
                        let person = NSKeyedUnarchiver.unarchiveObject(with: persondata) as! Person
                        print(person)
                    } catch {
                        print(error)
                    }
                }
            default:break
            }
        } catch {
            print(error)
        }
    }
    
    

}
