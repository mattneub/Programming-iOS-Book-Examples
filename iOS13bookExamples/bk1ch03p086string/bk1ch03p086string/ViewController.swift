

import UIKit

extension Int { // ruthlessly plagiarised :)
    func toRoman() -> String? {
        guard self > 0 else { return nil }
        let rom = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"]
        let ar = [1000,900,500,400,100,90,50,40,10,9,5,4,1]
        var result = ""
        var cur = self
        for (c, num) in zip(rom, ar) {
            let div = cur / num
            if (div > 0) {
                for _ in 0..<div { result += c }
                cur -= num * div
            }
        }
        return result
    }
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation(_ s: String, uppercased: Bool) {
        if uppercased {
            self.appendInterpolation(s.uppercased())
        } else {
            self.appendInterpolation(s)
        }
    }
    mutating func appendInterpolation(_ i: Int, roman: Bool) {
        if roman {
            if let r = i.toRoman() {
                self.appendInterpolation(r)
                return
            }
        }
        self.appendInterpolation(i)
    }
}


// simple example of an expressible by string literal
struct Vowelless : ExpressibleByStringLiteral, CustomStringConvertible {
    let value : String
    init(stringLiteral value: String) {
        self.value = value.filter { !"aeiou".contains($0) }
    }
    var description: String { value }
}

// example of expressible by string interpolation
// need to figure out whether I'm doing this quite right...
// see also https://nshipster.com/expressiblebystringinterpolation/
struct Romanizer : ExpressibleByStringLiteral, CustomStringConvertible {
    let value : String
    init(stringLiteral value: String) {
        self.value = value
    }
    var description: String { value }
}
extension Romanizer : ExpressibleByStringInterpolation {
    init(stringInterpolation: Interp) {
        self.init(stringLiteral: stringInterpolation.value)
    }
    struct Interp: StringInterpolationProtocol {
        var value: String = ""
        init(literalCapacity: Int, interpolationCount: Int) {
            self.value.reserveCapacity(literalCapacity)
        }
        mutating func appendLiteral(_ literal: String) {
            self.value.append(literal)
        }
        // mop up general cases
        mutating func appendInterpolation<T:LosslessStringConvertible>(_ s:T) {
            self.value.append(String(s))
        }
        // up that point is the minimum needed for string-like interpolation
        // now we add our special cases
        mutating func appendInterpolation(_ i: Int, roman: Bool) {
            if roman {
                if let r = i.toRoman() {
                    self.appendInterpolation(r)
                    return
                }
            }
            self.appendInterpolation(i)
        }
    }
}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do { // using a trivial expressible by string literal
            let v : Vowelless = "hello world"
            print(v.value)
        }
        
        do {
            var r : Romanizer = "this is a test"
            print(r)
            r = "this is a \("great") test I tell you \(5) times"
            print(r)
            r = "this is a \("great") test I tell you \(-5, roman:true) times"
            print(r)
            r = "this is a \("great") test I tell you \(5, roman:true) times"
            print(r)
        }
        
        do {
            // let pattern = "\\b\\d\\d\\b"
            let pattern = #"\b\d\d\b"# // new in Swift 5
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let s = """
            here is a number 24 let's see what happens
            """
            let range = regex.rangeOfFirstMatch(
                in: s, options: [],
                range: NSRange(s.startIndex..., in: s))
            print((s as NSString).substring(with: range))
        }
        
        func f() {
            // literal multiline strings new in Swift 4
            // indentation is gauged by the indentation of the second triple
            // it is a compile error if all lines are not indented that much
            // so the following has no white space before any line
            let s = """
            Line 1
                Line 2
            Line 3\n
            """
            print(s)
            print(Array(s).filter{$0 == "\n"}.count)
        }
        f()
        
        func g() {
            let s = """
            Line "1"
                Line 2 \
            and this is still Line 2
            """
            print(s)
        }
        g()

        do {
            let greeting = "hello"
            print(greeting)
            let leftTripleArrow = "\u{21DA}"
            print(leftTripleArrow)
            let n = 5
            let s = "You have \(n) widgets."
            print(s)
        }
        
        do {
            let m = 4
            let n = 5
            let s = "You have \(m + n) widgets."
            print(s)
        }
        
        do {
            // silly example of custom interpolation
            let adjective = "great"
            let s = "This is a \(adjective, uppercased:true) feature"
            print(s)
            // another silly example, I like this one better
            let n = 5
            print("You have \(n) widgets")
            print("You have \(n, roman:true) widgets")
            print("You have \(n, roman:false) widgets")
            print("You have \(-3, roman:true) widgets")
        }
        
        do {
            let ud = UserDefaults.standard
            // let s = "You have \(ud.integerForKey("widgets")) widgets." // compile error
            let n = ud.integer(forKey:"widgets")
            let s = "You have \(n) widgets."
            print(s)
        }
        
        do {
            let s = "hello"
            let s2 = " world"
            let greeting = s + s2
            print(greeting)
        }

        do {
            var s = "hello"
            let s2 = " world"
            // "extend" has changed to "appendContentsOf"
            // and again to "append", sheesh
            s.append(s2) // or: sss += sss2
            print(s)
        }

        do {
            let s = "hello"
            let s2 = "world"
            let space = " "
            // "join" has changed to "joinWithSeparator", which works the other way round
            // and now to "joined(separator:)", yipes
            let greeting = [s,s2].joined(separator: space)
            print(greeting)
        }
        
        do {
            print("hello".hasPrefix("he"))
            print("hello".hasSuffix("lo"))
        }

        do {
            let i = 7
            let s = String(i)
            print(s)
        }

        do {
            let i = 31
            let s = String(i, radix:16) // "1f"
            print(s)
        }
        
        do {
            let s = "31"
            let i = Int(s) // Optional(31)
            print(i as Any)
        }
        
        do {
            let s = "1f"
            let i = Int(s, radix:16) // Optional(31)
            print(i as Any)
        }
        
        do {
            let s = "31.34"
            let i = Int(s) // nil because it wasn't an Int; you don't get magical double-coercion
            print(i as Any)
        }
        
        // note elimination of characters from next two examples
        
        do {
            let s = "hello"
            let length = s.count // 5
            print(length)
        }
        
        do {
            let s = "hello"
            for c in s {
                print(c) // print each Character on its own line
            }
        }
        
        do {
            let c = "hello".last
            _ = c
        }


    }


}

