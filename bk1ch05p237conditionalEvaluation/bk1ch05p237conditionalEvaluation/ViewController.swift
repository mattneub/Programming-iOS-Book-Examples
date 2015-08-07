
import UIKit

enum Filter {
    case Albums
    case Playlists
    case Podcasts
    case Books
}


class ViewController: UIViewController {
    
    var currow : Int? = 0

    var hilite = false
    
    var type = Filter.Albums


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        let title = switch type { // compile error
        case .Albums:
            "Albums"
        case .Playlists:
            "Playlists"
        case .Podcasts:
            "Podcasts"
        case .Books:
            "Books"
        }
*/

        let title : String = {
            switch type {
            case .Albums:
                return "Albums"
            case .Playlists:
                return "Playlists"
            case .Podcasts:
                return "Podcasts"
            case .Books:
                return "Books"
            }
            }()
        print(title) // shut up compiler

        let cell = UITableViewCell()
        let ix = NSIndexPath(forRow: 0, inSection: 0)
        cell.accessoryType =
            ix.row == self.currow ? .Checkmark : .DisclosureIndicator

        let purple = UIColor.purpleColor()
        let beige = UIColor.brownColor()
        UIGraphicsBeginImageContext(CGSizeMake(10,10))
        let context = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(
            context, self.hilite ? purple.CGColor : beige.CGColor)
        UIGraphicsEndImageContext()
        
        do {
            let arr : [String?] = []
            do {
                let arr2 : [AnyObject] = arr.map {if $0 == nil {return NSNull()} else {return $0!}}
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

