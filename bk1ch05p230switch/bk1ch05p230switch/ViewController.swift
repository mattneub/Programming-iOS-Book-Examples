

import UIKit

class Dog {
    func bark() {}
}
class NoisyDog : Dog {
    func beQuiet() { print("arf arf arf") }
}

enum Filter : CustomStringConvertible {
    case Albums
    case Playlists
    case Podcasts
    case Books
    var description : String {
        switch self {
        case Albums:
            return "Albums"
        case Playlists:
            return "Playlists"
        case Podcasts:
            return "Podcasts"
        case Books:
            return "Books"
        }
    }
}

enum Error {
    case Number(Int)
    case Message(String)
    case Fatal
}


class ViewController: UIViewController {
    
    var navbar = UINavigationBar()
    var toolbar = UIToolbar()
    
    var progress = 0.0
    
    var d : Dog = NoisyDog()
    
    var i = 1
    var ii : Int? = nil
    var iii : AnyObject = 1
    
    var type : Filter = .Albums
    
    var err = Error.Number(-6)
    
    var pep = "Groucho"

    override func viewDidLoad() {
        super.viewDidLoad()

        switch i {
        case 1:
            print("You have 1 thingy!")
        case 2:
            print("You have 2 thingies!")
        default:
            print("You have \(i) thingies!")
        }
        
        switch i {
        case 1: print("You have 1 thingy!")
        case 2: print("You have 2 thingies!")
        default: print("You have \(i) thingies!")
        }

        switch i {
        case 1:
            print("You have 1 thingy!")
        case _:
            print("You have many thingies!")
        }
        
        switch i {
        case 1:
            print("You have 1 thingy!")
        case let n:
            print("You have \(n) thingies!")
        }

        switch i {
        case 1:
            print("You have 1 thingy!")
        case 2...10:
            print("You have \(i) thingies!")
        default:
            print("You have more thingies than I can count!")
        }
        
        do {
            let i = ii
            switch i {
            case nil: break
            default:
                switch i! {
                case 1:
                    print("You have 1 thingy!")
                case let n:
                    print("You have \(n) thingies!")
                }
            }
        }
        
        do { // new in Swift 2.0: question-mark suffix
            let i = ii
            switch i {
            case 1?:
                print("You have 1 thingy!")
            case let n?:
                print("You have \(n) thingies!")
            case nil: break
            }
        }
        
        switch i {
        case let j where j < 0:
            print("i is negative")
        case let j where j > 0:
            print("i is positive")
        case 0:
            print("i is 0")
        default:break
        }

        switch i {
        case _ where i < 0:
            print("i is negative")
        case _ where i > 0:
            print("i is positive")
        case 0:
            print("i is 0")
        default:break
        }

        switch d {
        case is NoisyDog:
            print("You have a noisy dog!")
        case _:
            print("You have a dog.")
        }
        
        switch d {
        case let nd as NoisyDog:
            nd.beQuiet()
        case let d:
            d.bark()
        }
        
        do {
            let i = iii
            switch i {
            case 0 as Int:
                print("It is 0")
            default:break
            }
        }
        
        do {
            let i = Optional(iii)
            switch i {
            case 0 as Int:
                print("It is 0")
            default:break
            }
        }


        do {
            let d : [NSObject:AnyObject] = [:]
            switch (d["size"], d["desc"]) {
            case let (size as Int, desc as String):
                print("You have size \(size) and it is \(desc)")
            default:break
            }
        }
        
        switch type {
        case .Albums:
            print("Albums")
        case .Playlists:
            print("Playlists")
        case .Podcasts:
            print("Podcasts")
        case .Books:
            print("Books")
        }

        switch err {
        case .Number(let theNumber):
            print("It is a .Number: \(theNumber)")
        case let .Message(theMessage):
            print("It is a .Message: \(theMessage)")
        case .Fatal:
            print("It is a .Fatal")
        }

        switch err {
        case let .Number(n) where n > 0:
            print("It's a positive error number \(n)")
        case let .Number(n) where n < 0:
            print("It's a negative error number \(n)")
        case .Number(0):
            print("It's a zero error number")
        default:break
        }

        switch err {
        case .Number(1..<Int.max):
            print("It's a positive error number")
        case .Number(Int.min...(-1)):
            print("It's a negative error number")
        case .Number(0):
            print("It's a zero error number")
        default:break
        }
        
        do {
            let i = ii
            switch i {
            case .None: break
            case .Some(1):
                print("You have 1 thingy!")
            case .Some(let n):
                print("You have \(n) thingies!")
            }
        }
        
        // new in Swift 2.0, case pattern syntax in an "if", "while", or "for"
        // the tag follows the pattern after an equal sign
        if case let .Number(n) = err {
            print("The error number is \(n)")
        }
        if case let .Number(n) = err where n < 0 {
            print("The negative error number is \(n)")
        }
        
        // and the inverse
        do {
            guard case let .Number(n) = err else {return}
            print("not to worry, it's a number: \(n)")
        }
        
        // note that most patterns will actually work here; for example, we had this:
        //        switch d {
        //        case let nd as NoisyDog:
        //            nd.beQuiet()
        // you can rewrite like this:
        do {
            if case let nd as NoisyDog = d {
                nd.beQuiet()
            }
        }
        // however, _that_ would be pointless, because there is already syntax for expressing that
        
        switch i {
        case 1,3,5,7,9:
            print("You have a small odd number of thingies.")
        case 2,4,6,8,10:
            print("You have a small even number of thingies.")
        default:
            print("You have too many thingies for me to count.")
        }

        do {
            let i = iii
            switch i {
            case is Int, is Double:
                print("It's some kind of number.")
            default:
                print("I don't know what it is.")
            }
        }
        
        switch pep {
        case "Manny": fallthrough
        case "Moe": fallthrough
        case "Jack":
            print("\(pep) is a Pep boy")
        default:
            print("I don't know who \(pep) is")
        }



        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "notificationArrived:", name: "test", object: nil)
        nc.postNotificationName("test", object: self, userInfo: ["junk":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":3])
    

    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        switch true {
        case bar === self.navbar:  return .TopAttached
        case bar === self.toolbar: return .Bottom
        default:                   return .Any
        }
    }
    
    func notificationArrived(n:NSNotification) {
        switch n.userInfo?["progress"] {
        case let prog as Double:
            self.progress = prog
        default:break
        }
        
        // but that seems a bit forced, since why wouldn't you just say:
        if let prog = n.userInfo?["progress"] as? Double {
            self.progress = prog
        }
    }




}

