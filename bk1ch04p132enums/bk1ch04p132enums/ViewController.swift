
import UIKit

enum Filter {
    case albums
    case playlists
    case podcasts
    case books
}

func filterExpecter(_ type:Filter) {
    if type == .albums {
        print("it's albums")
        print(type) // now actually useful!
    }
}

enum Filter2 : Int {
    case albums
    case playlists
    case podcasts
    case books
}

enum Filter2b : String {
    case albums
    case playlists
    case podcasts
    case books
}


enum Filter3 : String {
    case albums = "Albums"
    case playlists = "Playlists"
    case podcasts = "Podcasts"
    case books = "Audiobooks"
}

enum Error {
    case number(Int)
    case message(String)
    case fatal
}

enum Error2 {
    case number(Int)
    case message(String)
    case fatal(n:Int, s:String)
}



class ViewController: UIViewController {
    var err2 : Error2 = .fatal(n:-12, s:"Oh the horror")
    var s : String? = "howdy"

    override func viewDidLoad() {
        super.viewDidLoad()

        let type = Filter.albums
        let type2 : Filter = .albums
        filterExpecter(.albums)

        let v = UIView()
        v.contentMode = .center
        
        let type2b = Filter2b.albums
        print(type2b.rawValue) // albums (argh)
        
        let type3 = Filter3.albums
        print(type3.rawValue) // Albums
        
        let type4 = Filter3(rawValue:"Albums")
        // let type5 = Filter3("Albums") // nope
        if type4 == .albums { print("yep") }

        let err : Error = .number(4)

        let num = 4
        let errr : Error = .number(num)


        switch err2 {
        case .number(let theNumber):
            print("number: \(theNumber)")
        case .message(let theMessage):
            print("message: \(theMessage)")
        case .fatal(let theNumber, let theMessage):
            print("number: \(theNumber), message: \(theMessage)")
        }
        
        do {
            let fatalMaker = Error2.fatal
            let err = fatalMaker(n:-1000, s:"Unbelievably bad error")
            _ = err
        }

        switch s {
        case .some(let theString):
            print(theString) // howdy
        case .none:
            print("it's nil")
        }
        
        _ = type
        _ = type2
        _ = err
        _ = errr

    
    }



}

