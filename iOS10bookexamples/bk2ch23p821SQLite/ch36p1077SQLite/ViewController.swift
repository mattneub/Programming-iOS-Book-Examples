
import UIKit

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
        
        guard let db = FMDatabase(path:self.dbpath), db.open()
            else {print("Ooooops"); return}
        
        db.executeUpdate("create table people (lastname text, firstname text)", withArgumentsIn:[])
        
        db.beginTransaction()
        
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", withArgumentsIn:["Matt", "Neuburg"])
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", withArgumentsIn:["Snidely", "Whiplash"])
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", withArgumentsIn:["Dudley", "Doright"])
        db.commit()
        
        print("I think I created it")
        db.close()

    }
    
    @IBAction func doButton2 (_ sender: Any!) {
        guard let db = FMDatabase(path:self.dbpath), db.open()
            else {print("Ooooops"); return}
        
        if let rs = db.executeQuery("select * from people", withArgumentsIn:[]) {
            while rs.next() {
                print(rs["firstname"], rs["lastname"])
            }
        }
        db.close()

    }



}
