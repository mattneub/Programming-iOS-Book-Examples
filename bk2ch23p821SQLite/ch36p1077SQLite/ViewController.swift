
import UIKit
import SQLite3

// recast using pure Objective-C interface to FMDB, so that we are not dependent
// on any particular incarnation of Swift in FMDB itself

class ViewController: UIViewController {
    
    var dbpath : String {
        get {
            let docsdir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
            return (docsdir as NSString).appendingPathComponent("people.db")
        }
    }

    @IBAction func doButton (_ sender: Any!) {
        
        do {
            let fm = FileManager.default
            try fm.removeItem(atPath:self.dbpath) // in case we did this once already
        } catch {}
        
        let db = FMDatabase(path:self.dbpath)
        db.open()
        
        
        do {
            db.beginTransaction()
            
            try db.executeUpdate("create table people (lastname text, firstname text)", values:nil)
            try db.executeUpdate("insert into people (firstname, lastname) values (?,?)", values:["Matt", "Neuburg"])
            try db.executeUpdate("insert into people (firstname, lastname) values (?,?)", values:["Snidely", "Whiplash"])
            try db.executeUpdate("insert into people (firstname, lastname) values (?,?)", values:["Dudley", "Doright"])
        
            db.commit()
        } catch {
            db.rollback()
            print("something went wrong")
        }
        
        print("I think I created it")
        db.close()

    }
    
    @IBAction func doButton2 (_ sender: Any!) {
        let db = FMDatabase(path:self.dbpath)
        db.open()
        if let rs = try? db.executeQuery("select * from people", values:nil) {
            while rs.next() {
                if let firstname = rs["firstname"], let lastname = rs["lastname"] {
                    print(firstname, lastname)
                }
            }
        }
        db.close()

    }



}
