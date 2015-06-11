
import UIKit

class ViewController: UIViewController {
    
    var dbpath : String {
        get {
            let docsdir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as! String
            return docsdir.stringByAppendingPathComponent("people.db")
        }
    }

    @IBAction func doButton (sender:AnyObject!) {
        
        let fm = NSFileManager()
        fm.removeItemAtPath(self.dbpath, error:nil) // in case we did this once already
        
        let db = FMDatabase(path:self.dbpath)
        if !db.open() {
            println("Oooops")
            return
        }
        
        // NB Swift doesn't let us call executeUpdate:(NSString*)..., but we don't need to...
        // ...because there are other variants that we can call
        // if we really had to, we could call (or create, if it didn't exist)
        // the executeUpdate:withVAList: variant
        // (using the Swift getVaList function)
        
        db.executeUpdate("create table people (lastname text, firstname text)", withArgumentsInArray:nil)
        
        db.beginTransaction()
        
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", withArgumentsInArray:
        ["Matt", "Neuburg"])
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", withArgumentsInArray:
        ["Snidely", "Whiplash"])
        db.executeUpdate("insert into people (firstname, lastname) values (?,?)", withArgumentsInArray:
        ["Dudley", "Doright"])
        db.commit()
        
        println("I think I created it")
        db.close()

    }
    
    @IBAction func doButton2 (sender:AnyObject!) {
        let db = FMDatabase(path:self.dbpath)
        if !db.open() {
            println("Oooops")
            return
        }
        
        let rs = db.executeQuery("select * from people", withArgumentsInArray:nil)
        while rs.next() {
            print(rs["firstname"]); print(" "); println(rs["lastname"])
        }
        db.close()

    }



}
