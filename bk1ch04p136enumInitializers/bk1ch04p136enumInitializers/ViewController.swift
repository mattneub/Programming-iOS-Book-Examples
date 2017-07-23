

import UIKit
import MediaPlayer

enum Filter : String {
    case albums = "Albums"
    case playlists = "Playlists"
    case podcasts = "Podcasts"
    case books = "Audiobooks"
    static var cases : [Filter] = [.albums, .playlists, .podcasts, .books]
    init?(_ ix:Int) { // let's not encourage init! as I was doing before
        if !(0...3).contains(ix) { // in real life might say Filter.cases.indices.contains
            return nil
        }
        self = Filter.cases[ix]
    }
    init?(_ rawValue:String) {
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
        var ix = Filter.cases.index(of:self)!
        ix = (ix + 1) % 4
        self = Filter.cases[ix]
    }
    var query : MPMediaQuery {
        switch self {
        case .albums:
            return .albums()
        case .playlists:
            return .playlists()
        case .podcasts:
            return .podcasts()
        case .books:
            return .audiobooks()
        }
    }


}

enum Shape {
    case rectangle
    case ellipse
    case diamond
    func addShape (to p: CGMutablePath, in r: CGRect) -> () {
        switch self {
        case .rectangle:
            p.addRect(r)
        case .ellipse:
            p.addEllipse(in:r)
        case .diamond:
            p.move(to: CGPoint(x:r.minX, y:r.midY))
            p.addLine(to: CGPoint(x: r.midX, y: r.minY))
            p.addLine(to: CGPoint(x: r.maxX, y: r.midY))
            p.addLine(to: CGPoint(x: r.midX, y: r.maxY))
            p.closeSubpath()
        }
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let type1 = Filter.albums
        let type2 = Filter(rawValue:"Playlists")!
        let type3 = Filter(2) // .Podcasts, wrapped in a Optional

        let type4 = Filter(5) // nil
        
        let type5 = Filter("Playlists")
        
        print(type5?.description as Any)
        
        // type5.s = "test" // compile error
        var type6 = type5
        type6?.s = "test"
        
        var type7 = Filter.books
        type7.advance() // Filter.albums
        print(type7)

        _ = type1
        _ = type2
        _ = type3
        _ = type4
        _ = type5
    }


}

