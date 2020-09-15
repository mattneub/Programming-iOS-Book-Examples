

import UIKit

struct Person : Codable {
    let firstName : String
    let lastName : String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = ["Manny", "Moe", "Jack"]
        let fm = FileManager.default
        let temp = fm.temporaryDirectory
        let f = temp.appendingPathComponent("pep.plist")
        try! (arr as NSArray).write(to: f)
        // now let's see what we wrote
        let s = try! String.init(contentsOf: f)
        print(s)
        
        do {
            let fm = FileManager.default
            let temp = fm.temporaryDirectory
            let f = temp.appendingPathComponent("pep.plist")
            let arr = ["Manny", "Moe", "Jack"]
            let penc = PropertyListEncoder()
            penc.outputFormat = .xml
            let d = try! penc.encode(arr)
            try! d.write(to: f)
            //let s = String(data:d, encoding:.utf8)
            //print(s)
            
            // now let's see what we wrote
            let s = try! String.init(contentsOf: f)
            print(s)

        }
        
        do {
            let penc = PropertyListEncoder()
            penc.outputFormat = .xml
            let d = try! penc.encode(IndexSet([1,2,3]))
            let s = String(data:d, encoding:.utf8)!
            print(s)
            
            let ix = try! PropertyListDecoder().decode(IndexSet.self, from: d)
            print(Array(ix))
        }
        
        do {
            let p = Person(firstName: "Matt", lastName: "Neuburg")
            let penc = PropertyListEncoder()
            penc.outputFormat = .xml
            let d = try! penc.encode(p)
            let s = String(data:d, encoding:.utf8)!
            print(s)
            
            let p2 = try! PropertyListDecoder().decode(Person.self, from: d)
            print(p2)

        }
        
        do {
            let p = Person(firstName: "Matt", lastName: "Neuburg")
            let penc = PropertyListEncoder()
            penc.outputFormat = .xml
            let d = try! penc.encode([p])
            let s = String(data:d, encoding:.utf8)!
            print(s)
            
        }
        
        do {
            let ud = UserDefaults.standard
            
            let p = Person(firstName: "Matt", lastName: "Neuburg")
            let pdata = try! PropertyListEncoder().encode(p)
            ud.set(pdata, forKey: "person")
            
            if let pdata = ud.object(forKey: "person") as? Data {
                let p = try! PropertyListDecoder().decode(Person.self, from: pdata)
                print(p)
            }

        }


    
    }

}

