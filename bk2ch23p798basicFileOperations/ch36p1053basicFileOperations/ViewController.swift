

import UIKit

class ViewController: UIViewController {
    let query = NSMetadataQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // failed experiment; can't use NSMetadataQuery except in the iCloud folder
//        self.query.predicate = NSPredicate(format:"%K ENDSWITH '.txt'", NSMetadataItemFSNameKey)
//        self.query.startQuery()
    }

    @IBAction func doButton1 (_ sender: Any) {
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print(docs)
    }
    
    @IBAction func doButton2 (_ sender: Any) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsurl)
            print(docsurl.path)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton3 (_ sender: Any) {
        do {
            let fm = FileManager.default
            let suppurl = try fm.url(for:.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(suppurl)
        } catch {
            print(error)
        }
    }

    @IBAction func doButton4 (_ sender: Any) {
        do {
            let foldername = "MyFolder"
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let myfolder = docsurl.appendingPathComponent(foldername)
            
            try fm.createDirectory(at:myfolder, withIntermediateDirectories: true)
            
            // if we get here, myfolder exists
            // let's put a couple of files into it
            try "howdy".write(to: myfolder.appendingPathComponent("file1.txt"), atomically: true, encoding:.utf8)
            try "greetings".write(to: myfolder.appendingPathComponent("file2.txt"), atomically: true, encoding:.utf8)
            print("ok")
        } catch {
            print(error)
        }
    }

    @IBAction func doButton5 (_ sender: Any) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let arr = try fm.contentsOfDirectory(at:docsurl, includingPropertiesForKeys: nil)
            arr.forEach{ print($0.lastPathComponent) }
            // ======
    //        self.query.enumerateResultsUsingBlock {
    //            obj, ix, stop in
    //            print(obj)
    //        }
        } catch {
            print(error)
        }
    }
    
    @IBAction func doButton7 (_ sender: Any) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at:docsurl, includingPropertiesForKeys: nil)!
            for case let f as URL in dir where f.pathExtension == "txt" {
                print(f.lastPathComponent)
            }
        } catch {
            print(error)
        }
    }
    
    let which = 1
    
    @IBAction func doButton8 (_ sender: Any) {
        do {
            print("testing write array to file")
            let arr = ["Manny", "Moe", "Jack"]
            let temp = FileManager.default.temporaryDirectory
            let f = temp.appendingPathComponent("pep.plist")
            try (arr as NSArray).write(to: f) // new in iOS 11
        } catch {
            print(error)
        }
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            print("archiving Person using secure coding")
            let moi = Person(firstName: "Matt", lastName: "Neuburg")
            let moidata = try NSKeyedArchiver.archivedData(withRootObject: moi, requiringSecureCoding: true)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            
            print("serializing Person using property list encoder")
            let moi2 = Person2(firstName: "Matt", lastName: "Neuburg")
            let moidata2 = try PropertyListEncoder().encode(moi2)
            let moifile2 = docsurl.appendingPathComponent("moi2.txt")
            
            print("writing serialized Person2 to file")
            try moidata2.write(to: moifile2, options: .atomic)
            
            switch which {
            case 1:
                print("writing archived Person to file")
                try moidata.write(to: moifile, options: .atomic)
                var moifilevar = moifile // NB we need a var here
                var rv = URLResourceValues() // * new way, very nice
                rv.isExcludedFromBackup = true
                try moifilevar.setResourceValues(rv)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.writingIntent(with:moifile)
                fc.coordinate(with:[intent], queue: .main) { err in
                    // compiler gets confused if a one-liner returns a BOOL result
                    do {
                        print("writing archived Person to file")
                        try moidata.write(to: intent.url, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
            default:break
            }
            
            // note that you still can't save an array of Person as a plist,
            // even though Person adopts NSCoding
            // it won't turn itself automagically into a Data object
            
            let arr = [moi]
            let arrfile = docsurl.appendingPathComponent("arr.plist")
            print("attempting vainly to write an array of Person directly to disk")
            let ok = (arr as NSArray).write(to: arrfile, atomically: true)
            print(ok) // false
            
            // but now let's try the same thing with an Array of Person2 which is Codable
            // we can't just tell an Array to `write`, but we can write it as a plist
            let arr2 = [moi2]
            let arrfile2 = docsurl.appendingPathComponent("arr2.plist")
            let plister = PropertyListEncoder()
            plister.outputFormat = .xml // just so we can read it
            print("attempting successfully to write an array of Person2 by encoding to plist first")
            try plister.encode(arr2).write(to: arrfile2, options: .atomic)
            print("we didn't throw writing array of Person2")
            let s = try String.init(contentsOf: arrfile2)
            print(s) // show it as XML
        } catch {
            print(error)
        }
    }
    
    @IBAction func doButton9 (_ sender: Any) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
                let persondata = try Data(contentsOf: moifile)
                print("retrieving secure archived Person")
                let person = try NSKeyedUnarchiver.unarchivedObject(ofClass: Person.self, from: persondata)!
                print(person)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.readingIntent(with: moifile)
                fc.coordinate(with: [intent], queue: .main) { err in
                    do {
                        print("retrieving secure archived Person")
                        let persondata = try Data(contentsOf: intent.url)
                        if let person = try NSKeyedUnarchiver.unarchivedObject(ofClass: Person.self, from: persondata) {
                            print(person)
                        }
                    } catch {
                        print(error)
                    }
                }
            default:break
            }

//            let arrfile = docsurl.appendingPathComponent("arr.plist")
//            let arr = NSArray(contentsOf: arrfile)
//            print(arr)
            
            print("retrieving saved plist Person2")
            let moifile2 = docsurl.appendingPathComponent("moi2.txt")
            let persondata = try Data(contentsOf: moifile2)
            let person = try PropertyListDecoder().decode(Person2.self, from: persondata)
            print(person)
            
            print("retrieving saved plist array of Person2")
            let arrfile2 = docsurl.appendingPathComponent("arr2.plist")
            let arraydata = try Data(contentsOf: arrfile2)
            let arr = try PropertyListDecoder().decode([Person2].self, from:arraydata)
            print(arr)
        } catch {
            print(error)
        }
    }
    
    

}
