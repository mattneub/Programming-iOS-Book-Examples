
import UIKit

enum ListType {
    case Albums
    case Playlists
    case Podcasts
    case Books
}

func listTypeExpecter(type:ListType) {
    if type == .Albums {
        println("it's albums")
        println(type) // unhelpful
    }
}

enum ListType2 : Int {
    case Albums
    case Playlists
    case Podcasts
    case Books
}

enum ListType3 : String {
    case Albums = "Albums"
    case Playlists = "Playlists"
    case Podcasts = "Podcasts"
    case Books = "Audiobooks"
}

enum Error {
    case Number(Int)
    case Message(String)
    case Fatal
}

enum Error2 {
    case Number(Int)
    case Message(String)
    case Fatal(n:Int, s:String)
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let type = ListType.Albums
        let type2 : ListType = .Albums
        listTypeExpecter(.Albums)

        let v = UIView()
        v.autoresizingMask = .None
        
        let type3 = ListType3.Albums
        println(type3.rawValue) // Albums
        
        let type4 = ListType3(rawValue:"Albums")
        // let type5 = ListType3("Albums") // nope
        if type4 == .Albums { println("yep") }

        let err : Error = .Number(4)

        let num = 4
        let errr : Error = .Number(num)

        let err2 : Error2 = .Fatal(n:-12, s:"Oh the horror")

        switch err2 {
        case .Number(let theNumber):
            println("number: \(theNumber)")
        case .Message(let theMessage):
            println("message: \(theMessage)")
        case .Fatal(let theNumber, let theMessage):
            println("number: \(theNumber), message: \(theMessage)")
        }

        let s : String? = "howdy"
        switch s {
        case .Some(let theString):
            println(theString) // howdy
        case .None:
            println("it's nil")
        }

    
    }



}

