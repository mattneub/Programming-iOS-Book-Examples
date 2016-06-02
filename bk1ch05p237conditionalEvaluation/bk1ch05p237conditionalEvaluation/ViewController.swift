
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
        let ix = NSIndexPath(forRow: 0, inSection: 0)
        cell.accessoryType =
            ix.row == self.currow ? .checkmark : .disclosureIndicator

        let purple = UIColor.purple()
        let beige = UIColor.brown()
        UIGraphicsBeginImageContext(CGSize(width:10,height:10))
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.hilite ? purple.cgColor : beige.cgColor)
        UIGraphicsEndImageContext()
        
        do {
            let arr : [String?] = ["manny", nil, "jack"]
            do {
                let arr2 : [AnyObject] = arr.map {if $0 != nil {return $0!} else {return NSNull()}}
                print(arr2)
            }
            do {
                let arr2 = arr.map{ $0 != nil ? $0! : NSNull() }
                print(arr2)
            }
            do {
                let arr2 = arr.map{ $0 ?? NSNull() }
                print(arr2)
            }
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

        let i1 : AnyObject = 1
        let i2 : AnyObject = 2
        let someNumber = i1 as? Int ?? i2 as? Int ?? 0
        print(someNumber)

    
    }

}

