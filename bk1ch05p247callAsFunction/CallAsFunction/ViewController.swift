
import UIKit

// this is Apple's version
struct Adder {
    let base: Int
    init(_ base:Int) {
        self.base = base
    }
    func callAsFunction(_ addend:Int) -> Int {
        return self.base + addend
    }
    //
    func add(_ addend:Int) -> Int {
        return self.base + addend
    }
    //
    func makeAdder() -> (Int) -> Int {
        return { addend in self.base + addend }
    }
}

struct Person {
    let firstName : String
    let lastName : String
    func callAsFunction() -> String { self.firstName }
}

struct Greeter {
    let friendlyGreet : (String) -> String = { "Howdy, " + $0 }
    let unfriendlyGreet : (String) -> String = { "Go away, " + $0 }
    func greet(_ whom:String, with f:(String)->String) -> String { f(whom) }
}

struct Greeter2 {
    private let friendlyGreet : (String) -> String = { "Howdy, " + $0 }
    private let unfriendlyGreet : (String) -> String = { "Go away, " + $0 }
    func callAsFunction(welcomeGreetee s:String) -> String {self.friendlyGreet(s)}
    func callAsFunction(unwelcomeGreetee s:String) -> String {self.unfriendlyGreet(s)}
}

// =====

class GreetingFunctionMaker {
    var friendlyPrefix = "Howdy"
    var unfriendlyPrefix = "Go away"
    func generateFunction(prefix:String) -> (String) -> String {
        func result(suffix:String) -> String {
            prefix + ", " + suffix
        }
        return result
    }
}

struct Greeter3 {
    private let friendlyGreet : (String) -> String
    private let unfriendlyGreet : (String) -> String
    init() {
        let gm = GreetingFunctionMaker()
        self.friendlyGreet = gm.generateFunction(prefix:gm.friendlyPrefix)
        self.unfriendlyGreet = gm.generateFunction(prefix:gm.unfriendlyPrefix)
    }
    func callAsFunction(welcomeGreetee s:String) -> String {self.friendlyGreet(s)}
    func callAsFunction(unwelcomeGreetee s:String) -> String {self.unfriendlyGreet(s)}
}

// =====

class GreetingFunctionMaker2 {
    var friendlyPrefix = "Howdy"
    var unfriendlyPrefix = "Go away"
    func callAsFunction(prefix:String) -> (String) -> String {
        func result(suffix:String) -> String {
            prefix + ", " + suffix
        }
        return result
    }
}

struct Greeter4 {
    private let friendlyGreet : (String) -> String
    private let unfriendlyGreet : (String) -> String
    init() {
        let gm = GreetingFunctionMaker2()
        self.friendlyGreet = gm(prefix:gm.friendlyPrefix)
        self.unfriendlyGreet = gm(prefix:gm.unfriendlyPrefix)
    }
    func callAsFunction(welcomeGreetee s:String) -> String {self.friendlyGreet(s)}
    func callAsFunction(unwelcomeGreetee s:String) -> String {self.unfriendlyGreet(s)}
}

// =====

// based on idea from:
// https://www.swiftbysundell.com/articles/exploring-swift-5-2s-new-functional-features/
struct F<Input1,Input2,Output> {
    let underlyingFunction : (Input1,Input2) -> Output
    init(_ f: @escaping (Input1,Input2) -> Output) {
        self.underlyingFunction = f
    }
    func callAsFunction(_ input1: Input1, _ input2: Input2) -> Output {
        underlyingFunction(input1, input2)
    }
}

extension F {
    func partiallyApplied(_ input1:Input1) -> (Input2) -> Output {
        func result(input2:Input2) -> Output {
            self(input1,input2)
        }
        return result
    }
}

class GreetingFunctionMaker3 {
    var friendlyPrefix = "Howdy"
    var unfriendlyPrefix = "Go away"
    private lazy var f = F<String,String,String> { prefix, suffix in
        prefix + ", " + suffix
    }
    func callAsFunction(prefix:String) -> (String) -> String {
        f.partiallyApplied(prefix)
    }
}

struct Greeter5 {
    private let friendlyGreet : (String) -> String
    private let unfriendlyGreet : (String) -> String
    init() {
        let gm = GreetingFunctionMaker3()
        self.friendlyGreet = gm(prefix:gm.friendlyPrefix)
        self.unfriendlyGreet = gm(prefix:gm.unfriendlyPrefix)
    }
    func callAsFunction(welcomeGreetee s:String) -> String {self.friendlyGreet(s)}
    func callAsFunction(unwelcomeGreetee s:String) -> String {self.unfriendlyGreet(s)}
}

// =====

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add3 = Adder(3)
        let sum = add3(4)
        print(sum) // 7
        
        let sum2 = add3.add(4)
        print(sum2) // 7
        let add3function = add3.makeAdder()
        let sum3 = add3function(4)
        print(sum3) // 7
        
        let p = Person(firstName: "Matt", lastName: "Neuburg")
        let s = p()
        print(s) // Matt

        do {
            let g = Greeter()
            let s = g.greet("Matt", with:g.friendlyGreet)
            print(s)
        }

        do {
            let greet = Greeter2()
            let s = greet(welcomeGreetee:"Matt")
            print(s)
        }
        
        do {
            let greet = Greeter3()
            let s = greet(welcomeGreetee:"Matt")
            print(s)
        }

        do {
            let greet = Greeter4()
            let s = greet(welcomeGreetee:"Matt")
            print(s)
        }
        
        do {
            let greet = Greeter5()
            let s = greet(welcomeGreetee:"Matt")
            print(s)
        }

        
    }


}

