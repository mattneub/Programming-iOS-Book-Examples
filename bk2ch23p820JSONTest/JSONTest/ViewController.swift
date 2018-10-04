
import UIKit

// not used; just testing the syntax
struct Person: Decodable {
    var firstName: String
    var lastName: String
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}


struct Outer : Decodable {
    let categoryName : String
    let unknown : [Inner]
    struct Inner : Decodable {
        let category : String
        let price : Double
        let isFavourite : Bool?
        let isWatchlist : Bool?
    }
    private struct CK : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    init(from decoder: Decoder) throws {
        let con = try decoder.container(keyedBy: CK.self)
        self.categoryName = try con.decode(String.self, forKey:CK(stringValue:"categoryName")!)
        self.unknown = try con.decode([Inner].self, forKey: CK(stringValue:self.categoryName)!)
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // here is some sample JSON:
        
        let json = """
        [
            {
              "categoryName": "Trending",
              "Trending": [
                {
                  "category": "Trending",
                  "price": 20.5,
                  "isFavourite": true,
                  "isWatchlist": null
                }
              ]
            },
            {
              "categoryName": "Comedy",
              "Comedy": [
                {
                  "category": "Comedy",
                  "price": 24.32,
                  "isFavourite": null,
                  "isWatchlist": false
                }
              ]
            }
        ]
        """
        
        let jsondata = json.data(using: .utf8)!
        
        let myjson = try! JSONDecoder().decode([Outer].self, from: jsondata)
        print(myjson)

        
        
    }



}

