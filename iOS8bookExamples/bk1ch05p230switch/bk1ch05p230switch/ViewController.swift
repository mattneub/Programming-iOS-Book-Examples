

import UIKit

class Dog {
    func bark() {}
}
class NoisyDog : Dog {
    func beQuiet() {}
}

enum ListType : Printable {
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
    var ii : Int? = 1
    var iii : AnyObject = 1
    
    var type : ListType = .Albums
    
    var err = Error.Number(-6)
    
    var pep = "Groucho"

    override func viewDidLoad() {
        super.viewDidLoad()

        switch i {
        case 1:
            println("You have 1 thingy!")
        case 2:
            println("You have 2 thingies!")
        default:
            println("You have \(i) thingies!")
        }
        
        switch i {
        case 1: println("You have 1 thingy!")
        case 2: println("You have 2 thingies!")
        default: println("You have \(i) thingies!")
        }

        switch i {
        case 1:
            println("You have 1 thingy!")
        case _:
            println("You have many thingies!")
        }
        
        switch i {
        case 1:
            println("You have 1 thingy!")
        case let n:
            println("You have \(n) thingies!")
        }

        switch i {
        case 1:
            println("You have 1 thingy!")
        case 2...10:
            println("You have \(i) thingies!")
        default:
            println("You have more thingies than I can count!")
        }
        
        switch ii {
        case nil: break
        default:
            switch ii! {
            case 1:
                println("You have 1 thingy!")
            case let n:
                println("You have \(n) thingies!")
            }
        }
        
        switch i {
        case let j where j < 0:
            println("i is negative")
        case let j where j > 0:
            println("i is positive")
        case 0:
            println("i is 0")
        default:break
        }

        switch i {
        case _ where i < 0:
            println("i is negative")
        case _ where i > 0:
            println("i is positive")
        case 0:
            println("i is 0")
        default:break
        }

        switch d {
        case is NoisyDog:
            println("You have a noisy dog!")
        case _:
            println("You have a dog.")
        }
        
        switch d {
        case let nd as NoisyDog:
            nd.beQuiet()
        case let d:
            d.bark()
        }
        
        switch iii {
        case 0 as Int:
            println("It is 0")
        default:break
        }

        if true {
            let d : [NSObject:AnyObject] = [:]
            switch (d["size"], d["desc"]) {
            case let (size as Int, desc as String):
                println("You have size \(size) and it is \(desc)")
            default:break
            }
        }
        
        switch type {
        case .Albums:
            println("Albums")
        case .Playlists:
            println("Playlists")
        case .Podcasts:
            println("Podcasts")
        case .Books:
            println("Books")
        }

        switch err {
        case .Number(let theNumber):
            println("It is a .Number: \(theNumber)")
        case let .Message(theMessage):
            println("It is a .Message: \(theMessage)")
        case .Fatal:
            println("It is a .Fatal")
        }

        switch err {
        case let .Number(n) where n > 0:
            println("It's a positive error number \(n)")
        case let .Number(n) where n < 0:
            println("It's a negative error number \(n)")
        case .Number(0):
            println("It's a zero error number")
        default:break
        }

        switch err {
        case .Number(1..<Int.max):
            println("It's a positive error number")
        case .Number(Int.min...(-1)):
            println("It's a negative error number")
        case .Number(0):
            println("It's a zero error number")
        default:break
        }

        switch i {
        case 1,3,5,7,9:
            println("You have a small odd number of thingies.")
        case 2,4,6,8,10:
            println("You have a small even number of thingies.")
        default:
            println("You have too many thingies for me to count.")
        }

        switch iii {
        case is Int, is Double:
            println("It's some kind of number.")
        default:
            println("I don't know what it is.")
        }
        
        switch pep {
        case "Manny": fallthrough
        case "Moe": fallthrough
        case "Jack":
            println("\(pep) is a Pep boy")
        default:
            println("I don't know who \(pep) is")
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
    }




}

