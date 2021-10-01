
import UIKit

protocol Attribute {
}

extension RawRepresentable where Self:Attribute { // brilliant idea from Stack Overflow
    var description : String { return "\(self.rawValue)" }
    init?(_ what:RawValue) {
        self.init(rawValue:what)
    }
}

enum Fill : Int, CustomStringConvertible, Attribute, Codable {
    case empty = 1
    case solid
    case hazy
}

enum Color : Int, CustomStringConvertible, Attribute, Codable {
    case color1 = 1
    case color2
    case color3
}

enum Shape : Int, CustomStringConvertible, Attribute, Codable {
    case rectangle = 1
    case ellipse
    case diamond
}

enum Number : Int, CustomStringConvertible, Attribute, Codable {
    case one = 1
    case two
    case three
}

public struct Card: Codable, CustomStringConvertible {
    let itsColor : Color
    let itsNumber : Number
    let itsShape : Shape
    let itsFill : Fill
    
    public static let countOfAttributes = 4
    public subscript(ix: Int) -> Int {
        let arr : [Int] = [self.itsColor.rawValue, self.itsNumber.rawValue, self.itsShape.rawValue, self.itsFill.rawValue]
        return arr[ix]
    }
    
    public var description : String {
        return "\(self.itsColor) \(self.itsNumber) \(self.itsShape) \(self.itsFill)"
    }
    
    init ( color c: Color, number n: Number, shape s: Shape, fill f: Fill ) {
        self.itsColor = c
        self.itsNumber = n
        self.itsShape = s
        self.itsFill = f
    }
    
    init (_ c:Int, _ n:Int, _ s:Int, _ f:Int) {
        self.init(
            color:Color(c)!,
            number:Number(n)!,
            shape:Shape(s)!,
            fill:Fill(f)!
        )
    }
}

public final class Deck: Codable, CustomStringConvertible {
    public private(set) var cards : [Card]
    
    public var description : String { return self.cards.description }
    
    public init () {
        self.cards = []
        for i in 1...3 {
            for ii in 1...3 {
                for iii in 1...3 {
                    for iiii in 1...3 {
                        self.cards.append(Card(i, ii, iii, iiii))
                    }
                }
            }
        }
    }
    
    public func shuffle () -> () {
        self.cards.shuffle()
    }
    
    public func deal () -> (Card?) {
        let card = self.cards.count == 0 ? nil : self.cards.remove(at: 0)
        return card
    }
    
    public func undeal ( _ c: Card ) {
        self.cards.insert(c, at: 0)
    }
    
}

