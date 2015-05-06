

import UIKit

enum ListType : String {
    case Albums = "Albums"
    case Playlists = "Playlists"
    case Podcasts = "Podcasts"
    case Books = "Audiobooks"
    static var cases : [ListType] = [Albums, Playlists, Podcasts, Books]
    init!(_ ix:Int) {
        if !(0...3).contains(ix) {
            return nil
        }
        self = ListType.cases[ix]
    }
    init!(_ rawValue:String) {
        self.init(rawValue:rawValue)
    }
    var description : String { return self.rawValue }
    var s : String {
        get {
            return "howdy"
        }
        set {}
    }
    mutating func advance() {
        var ix = find(ListType.cases, self)!
        ix = (ix + 1) % 4
        self = ListType.cases[ix]
    }

}

enum ShapeMaker {
    case Rectangle
    case Ellipse
    case Diamond
    func drawShape (p: CGMutablePath, inRect r : CGRect) -> () {
        switch self {
        case Rectangle:
            CGPathAddRect(p, nil, r)
        case Ellipse:
            CGPathAddEllipseInRect(p, nil, r)
        case Diamond:
            CGPathMoveToPoint(p, nil, r.minX, r.midY)
            CGPathAddLineToPoint(p, nil, r.midX, r.minY)
            CGPathAddLineToPoint(p, nil, r.maxX, r.midY)
            CGPathAddLineToPoint(p, nil, r.midX, r.maxY)
            CGPathCloseSubpath(p)
        }
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let type1 = ListType.Albums
        let type2 = ListType(rawValue:"Playlists")!
        let type3 = ListType(2) // .Podcasts

        let type4 = ListType(5) // nil
        
        let type5 = ListType("Playlists")
        
        println(type5.description)
        
        // type5.s = "test" // compile error
        var type6 = type5
        type6.s = "test"
        
        var type7 = ListType.Books
        type7.advance() // ListType.Albums

    
    }


}

