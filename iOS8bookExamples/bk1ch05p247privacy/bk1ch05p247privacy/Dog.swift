
class Dog {
    var name = ""
    private var whatADogSays = "woof"
    func bark() {
        println(self.whatADogSays)
    }
    func speak() {
        println(self.whatADogSays)
    }
    func nameCat(cat:Cat) {
        cat.secretName = "Lazybones" // legal: same file
    }
    func nameCat2(cat:Cat2) {
        // cat.secretName = "Lazybones" // illegal: different file
    }
}

class Cat {
    private var secretName : String? = nil
}

