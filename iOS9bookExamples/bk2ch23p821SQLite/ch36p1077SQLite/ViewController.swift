
import UIKit

class ViewController: UIViewController {
    
    var dbpath : String {
        get {
            let docsdir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
            return (docsdir as NSString).stringByAppendingPathComponent("people.db")
        }
    }

    @IBAction func doButton (sender:AnyObject!) {
        
        do {
            let fm = NSFileManager()
            try fm.removeItemAtPath(self.dbpath) // in case we did this once already
        } catch {}
        
        let db = FMDatabase(path:self.dbpath)
        if !db.open() {
            print("Oooops")
            return
        }
        
        db.executeUpdate("create table people (lastname text, firstname text)")
        
        db.beginTransaction()
        
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", "Matt", "Neuburg")
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", "Snidely", "Whiplash")
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", "Dudley", "Doright")
        db.commit()
        
        print("I think I created it")
        db.close()

    }
    
    @IBAction func doButton2 (sender:AnyObject!) {
        let db = FMDatabase(path:self.dbpath)
        if !db.open() {
            print("Oooops")
            return
        }
        
        if let rs = db.executeQuery("select * from people") {
            while rs.next() {
                print(rs["firstname"], rs["lastname"])
            }
        }
        db.close()

    }



}
