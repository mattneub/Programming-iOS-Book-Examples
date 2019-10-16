
import UIKit

enum Normal : Double {
    case fahrenheit = 98.6
    case centigrade = 37
}

enum PepBoy : Int {
    case manny
    case moe
    case jack
}

enum PepBoy2 : Int {
    case manny = 1
    case moe
    case jack = 4
}


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

enum MyError {
    case number(Int)
    case message(String)
    case fatal
}

enum MyError2 {
    case number(Int)
    case message(String)
    case fatal(n:Int, s:String)
}

enum MyError3 : Equatable {
    case number(Int)
    case message(String)
    case fatal
}


class ViewController: UIViewController {
    var err2 : MyError2 = .fatal(n:-12, s:"Oh the horror") // labels required
    var s : String? = "howdy"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testRawRepresentable()

        let type = Filter.albums
        let type2 : Filter = .albums
        filterExpecter(.albums)

        let v = UIView()
        v.contentMode = .center
        
        let type2b = Filter2b.albums
        print(type2b) // albums (NEW: no need to ask for raw value to print case!)
        
        let type3 = Filter3.albums
        print(type3.rawValue) // Albums (because the raw value for this one is different)
        
        let type4 = Filter3(rawValue:"Albums")
        // let type5 = Filter3("Albums") // nope
        if type4 == .albums { print("yep") }

        let err : MyError = .number(4)

        let num = 4
        let errr : MyError = .number(num)


        switch err2 {
        case .number(let theNumber):
            print("number: \(theNumber)")
        case .message(let theMessage):
            print("message: \(theMessage)")
        case .fatal(let theNumber, let theMessage):
            print("number: \(theNumber), message: \(theMessage)")
        }
        
        do {
            let fatalMaker = MyError2.fatal
            // let errr = fatalMaker(n:-1000, s:"Unbelievably bad error")
            // Xcode 9 beta 2 change: must omit the labels? But only in the initializer????
            let err = fatalMaker(-1000, "Unbelievably bad error") // labels must be omitted; the inconsistency is surely a bug
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
        
        print(PepBoy2.moe.rawValue)
        
        do {
            let temp = Normal.fahrenheit
            let ok = temp == Normal.fahrenheit
            print(ok)
            let opt = Optional("howdy")
            let ok2 = opt == Optional.none
            print(ok2)
            let err = MyError.fatal
            // let ok3 = err == MyError.fatal
            if case .fatal = err { // this is how you have to do it
                print("yep, it's fatal")
            }
            _ = err
            // but hold my beer and watch this!
            let err2 = MyError3.fatal
            let ok4 = err2 == MyError3.fatal // legal because we declared the thing Equatable
            _ = ok4
            
            
        }
    
    }
    
    func testRawRepresentable() {
        // proving that an enum with a raw value is a RawRepresentable
        enum E {
            case howdy
            case farewell
        }
        enum E2 : String {
            case howdy
            case farewell
        }
        func f<T:RawRepresentable>(_ t:T) {
            print("you passed me a RawRepresentable")
        }
        // f(E.howdy) // error
        f(E2.howdy) // you passed me a RawRepresentable
    }



}

