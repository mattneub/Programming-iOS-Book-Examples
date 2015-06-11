
import UIKit

enum ListType {
    case Albums
    case Playlists
    case Podcasts
    case Books
}


class ViewController: UIViewController {
    
    var currow : Int? = 0

    var hilite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var type = ListType.Albums
        

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

        let cell = UITableViewCell()
        let ix = NSIndexPath(forRow: 0, inSection: 0)
        cell.accessoryType =
            ix.row == self.currow ? .Checkmark : .DisclosureIndicator

        let purple = UIColor.purpleColor()
        let beige = UIColor.brownColor()
        UIGraphicsBeginImageContext(CGSizeMake(10,10))
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(
            context, self.hilite ? purple.CGColor : beige.CGColor)
        UIGraphicsEndImageContext()
        
        if true {
            let arr : [String?] = []
            let arr2 = arr.map{ $0 == nil ? NSNull() : $0! }
            let arr3 = arr.map{ $0 ?? NSNull() }
        }
        
        if true {
            let arr : [AnyObject] = []
            let arr2 : [String] = arr.map {
                if $0 is String {
                    return $0 as! String
                } else {
                    return ""
                }
            }
            let arr3 = arr.map { $0 as? String ?? "" }
        }

        var i1 : AnyObject = 1
        var i2 : AnyObject = 2
        let someNumber = i1 as? Int ?? i2 as? Int ?? 0

    
    }

}

