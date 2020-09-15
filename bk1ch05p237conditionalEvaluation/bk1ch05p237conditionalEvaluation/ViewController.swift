
import UIKit

enum Filter {
    case albums
    case playlists
    case podcasts
    case books
}


class ViewController: UIViewController {
    
    
    var currow : Int? = 0

    var hilite = false
    
    var type = Filter.albums
    
    var firstRed = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        let title = switch type { // compile error
        case .albums:
            "Albums"
        case .playlists:
            "Playlists"
        case .podcasts:
            "Podcasts"
        case .books:
            "Books"
        }
*/

        let title : String = {
            switch type {
            case .albums:
                return "Albums"
            case .playlists:
                return "Playlists"
            case .podcasts:
                return "Podcasts"
            case .books:
                return "Books"
            }
            }()
        print(title) // shut up compiler

        let cell = UITableViewCell()
        let ix = IndexPath(row: 0, section: 0)
        cell.accessoryType =
            ix.row == self.currow ? .checkmark : .disclosureIndicator

        let purple = UIColor.purple
        let beige = UIColor.brown
        UIGraphicsBeginImageContext(CGSize(width:10,height:10))
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.hilite ? purple.cgColor : beige.cgColor)
        UIGraphicsEndImageContext()
        
        let v1 = UIView()
        let v2 = UIView()
        (self.firstRed ? v1 : v2).backgroundColor = .red
        
        do {
            let arr : [String?] = ["manny", nil, "jack"]
            
            do {
                let arr2:[Any] = arr.map {if $0 != nil {return $0!} else {return NSNull()}}
                print(arr2)
            }
            do {
                let arr2 = arr.map {$0 != nil ? $0! : NSNull() as Any }
                print(arr2)
            }
            do {
                let arr2 = arr.map {$0 ?? NSNull() as Any}
                print(arr2)
            }
        }
        
        // however, I'm pretty sure the above is unnecessary now,
        // as we will bridge that way automatically
        
        do {
            let arr : [String?] = ["manny", nil, "jack"]
            let arr2 = arr as AnyObject
            print(arr2) // yep, looks like it
            let marr = NSMutableArray(array:arr as NSArray)
            marr.add("moe")
            let arr3 = marr as! [String?]
            print(arr3)
        }
        
        do {
            let arr : [AnyObject] = []
            do {
                let arr2 : [String] = arr.map {
                    if $0 is String {
                        return $0 as! String
                    } else {
                        return ""
                    }
                }
                print(arr2)
            }
            do {
                let arr2 = arr.map { $0 as? String ?? "" }
                print(arr2)
            }
        }
        
        do {
            let arr = ["Manny", "Moe", "Jack"]
            let target = "Matt"
            let pos = arr.firstIndex(of:target)
            let s = pos != nil ? String(pos!) : "NOT FOUND"
            _ = s
        }

        do {
            let arr = ["Manny", "Moe", "Jack"]
            let target = "Matt"
            let s = arr.firstIndex(of:target).map {String($0)} ?? "NOT FOUND"
            _ = s
        }


        let i1 : Any = 1
        let i2 : Any = 2
        let someNumber = i1 as? Int ?? i2 as? Int ?? 0
        print(someNumber)
    
    }

}

class MyClass : UITableViewController {
    var titles : [String]?
    override func tableView(_ tv: UITableView, numberOfRowsInSection sec: Int) -> Int {
        return self.titles?.count ?? 0
    }

}

