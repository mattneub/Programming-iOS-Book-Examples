

import UIKit
import MediaPlayer

enum Filter : String, CaseIterable {
    case albums = "Albums"
    case playlists = "Playlists"
    case podcasts = "Podcasts"
    case books = "Audiobooks"
    // static let cases : [Filter] = [.albums, .playlists, .podcasts, .books]
    init?(_ ix:Int) {
        if !Filter.allCases.indices.contains(ix) {
            return nil
        }
        self = Filter.allCases[ix]
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
        let cases = Self.allCases
        var ix = cases.firstIndex(of:self)!
        ix = (ix + 1) % cases.count
        self = cases[ix]
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

@propertyWrapper struct Test {
    var wrappedValue : String {
        get { "howdy" }
        set {}
    }
}

enum E {
    case one
    case two
    @Test static var s : String // ok
    // @Test var s : String // nope
}

enum Silly {
    case one
    var sillyProperty : String {
        get { "Howdy" }
        set {} // do nothing
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let type1 = Filter.albums
        let type2 = Filter(rawValue:"Playlists")!
        let type3 = Filter(2) // .podcasts, wrapped in a Optional

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
        
        var silly = Silly.one
        silly.sillyProperty = "silly"
    }


}

