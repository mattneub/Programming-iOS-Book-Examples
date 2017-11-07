

import UIKit

class MyDocument: UIDocument {
    
    var string = "This is a failure"
    
    override func load(fromContents contents: Any,
                       ofType typeName: String?) throws {
        if let contents = contents as? Data {
            if let s = String(data: contents, encoding: .utf8) {
                self.string = s
                return
            }
        }
        throw NSError(domain: "NoDataDomain", code: -1, userInfo: nil)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        if let data = self.string.data(using: .utf8) {
            return data
        }
        throw NSError(domain: "NoDataDomain", code: -2, userInfo: nil)
    }


}
