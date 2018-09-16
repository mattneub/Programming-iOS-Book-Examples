

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class PeopleDocument: UIDocument {
    
    var people = [Person]()
    
    override func load(fromContents contents: Any,
        ofType typeName: String?) throws {
            print("loading \(typeName as Any)")
            if let contents = contents as? Data {
                if let arr = try? PropertyListDecoder().decode([Person].self, from: contents) {
                    self.people = arr
                    print("loaded \(self.people)")
                    return // all's well that ends well
                }
            }
            // if we get here, there was some kind of problem
            throw NSError(domain: "NoDataDomain", code: -1, userInfo: nil)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        print("archiving \(typeName)")
        if let data = try? PropertyListEncoder().encode(self.people) {
            return data
        }
        // if we get here, there was some kind of problem
        throw NSError(domain: "NoDataDomain", code: -2, userInfo: nil)
    }
    
    // ??? I don't see that this does anything perceptible
    // okay, but we need to try again, there may have been a bug in how was renamified...
    // ...and so I may have been forced to configure the returned dictionary incorrectly
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        let icon = UIImage(named:"smiley.jpg")! // yup, it's working now!
        let sz = CGSize(1024,1024)
        let im = UIGraphicsImageRenderer(size:sz, format:icon.imageRendererFormat).image {_ in
            icon.draw(at: CGPoint(
                (sz.width - icon.size.width)/2,
                (sz.height - icon.size.height)/2))
        }
        var d = try super.fileAttributesToWrite(to: url, for: saveOperation)
        let key1 = URLResourceKey.thumbnailDictionaryKey
        let key2 = URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey
        d[key1] = [key2:im]
        return d
    }
    
}
