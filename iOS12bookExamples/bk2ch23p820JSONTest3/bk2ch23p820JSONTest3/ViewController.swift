
import UIKit

// not in the book: combines unknown keys (Hamish's AnyCodingKey) and unknown types (union enum for string-or-integer)

struct Animal: Decodable {
    var d = [String : Sint]()
    struct AnyCodingKey : CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init(_ codingKey: CodingKey) {
            self.stringValue = codingKey.stringValue
            self.intValue = codingKey.intValue
        }
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        init(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
    init(from decoder: Decoder) throws {
        let con = try decoder.container(keyedBy: AnyCodingKey.self)
        for key in con.allKeys {
            let result = try con.decode(Sint.self, forKey: key)
            self.d[key.stringValue] = result
        }
    }
}
enum Sint : Decodable {
    case string(String)
    case int(Int)
    enum Err : Error { case oops }
    init(from decoder: Decoder) throws {
        let con = try decoder.singleValueContainer()
        if let s = try? con.decode(String.self) {
            self = .string(s)
            return
        }
        if let i = try? con.decode(Int.self) {
            self = .int(i)
            return
        }
        throw Err.oops
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.test()
    }

    func test() {
        let j1 = """
        {
        "tag": 12,
        "name": "Dog",
        "type": "TYPE1"
        }
        """
        let j2 = """
        {
        "what": "ANIMAL",
        "name": "Dog",
        "sort": 1
        }
        """
        let d1 = j1.data(using: .utf8)!
        let a1 = try! JSONDecoder().decode(Animal.self, from: d1)
        let d2 = j2.data(using: .utf8)!
        let a2 = try! JSONDecoder().decode(Animal.self, from: d2)
        print(a1)
        print(a2)
    }

}

