import UIKit

class Dog {
    var name = ""
    private var whatADogSays = "woof"
    func bark() {
        print(self.whatADogSays)
    }
    func nameCat(cat:Cat) {
        cat.secretName = "Lazybones" // legal: same file
        let k = Kangaroo()
        _ = k
    }
    func nameCat2(cat:Cat2) {
        // cat.secretName = "Lazybones" // illegal: different file
    }
}

extension Dog {
    func speak() {
        print(self.whatADogSays)
    }
}

class Cat {
    fileprivate var secretName : String?
    private(set) var color : UIColor?
    fileprivate(set) var length : Double?
}

private class Kangaroo {
    
}

