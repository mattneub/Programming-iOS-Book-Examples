

import UIKit
import MobileCoreServices
import Contacts

final class Person : NSObject, Codable {
    
    let firstName: String
    let lastName: String
    init(firstName:String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }
    override var description : String {
        return self.firstName + " " + self.lastName
    }
    enum MyError : Error { case oops }
    static let personUTI = "neuburg.matt.person"
}

extension Person : NSItemProviderWriting {
    
    // this means that a Person can be dragged to where a string is expected
    static var writableTypeIdentifiersForItemProvider =
        [personUTI, kUTTypeUTF8PlainText as String]
    
    func loadData(withTypeIdentifier typeid: String, forItemProviderCompletionHandler ch: @escaping (Data?, Error?) -> Void) -> Progress? {
        switch typeid {
        case type(of:self).personUTI:
            do {
                ch(try PropertyListEncoder().encode(self), nil)
            } catch {
                ch(nil, error)
            }
        case kUTTypeUTF8PlainText as NSString as String:
            ch(self.description.data(using: .utf8)!, nil)
        default: ch(nil, MyError.oops)
        }
        return nil
    }
}

extension Person : NSItemProviderReading {
    
    // this means that a string can be dragged to where a Person is expected
    static var readableTypeIdentifiersForItemProvider = [personUTI, kUTTypeVCard as String, kUTTypeUTF8PlainText as String]
    
    static func object(withItemProviderData data: Data, typeIdentifier typeid: String) throws -> Self {
        switch typeid {
        case personUTI:
            do {
                let p = try PropertyListDecoder().decode(self, from: data)
                return p
            } catch {
                throw error
            }
        case kUTTypeUTF8PlainText as NSString as String:
            if let s = String(data: data, encoding: .utf8) {
                let arr = s.split(separator:" ")
                let first = arr.dropLast().joined(separator: " ")
                let last = arr.last ?? ""
                return self.init(firstName: first, lastName: String(last))
            }
            throw MyError.oops
        case kUTTypeVCard as NSString as String:
            do {
                let con = try CNContactVCardSerialization.contacts(with: data)[0]
                if con.givenName.isEmpty && con.familyName.isEmpty {
                    throw MyError.oops
                }
                return self.init(firstName: con.givenName, lastName: con.familyName)
            } catch {
                throw MyError.oops
            }
        default: throw MyError.oops
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragger = UIDragInteraction(delegate: self)
        self.dragView.addInteraction(dragger)
        
        let dropper = UIDropInteraction(delegate: self)
        self.dropView.addInteraction(dropper)
    }
}

extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let ip = NSItemProvider(object: Person(firstName: "Matt", lastName: "Neuburg"))
        let di = UIDragItem(itemProvider: ip)
        return [di]
    }
}

// this is the Really Interesting Part: if you change Person to NSString throughout...
// ... then this still works, because Person also supplies itself as a string.
// In that case, Person's `object(withItemProviderData` is never called,
// because the type being asked to interpret the data is NSString!

extension ViewController : UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let op : UIDropOperation = session.canLoadObjects(ofClass: Person.self) ? .copy : .cancel
        return UIDropProposal(operation:op)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for item in session.items {
            let ip = item.itemProvider
            ip.loadObject(ofClass: Person.self) { person, err in
                if let person = person as? Person {
                    print("Person:", person)
                }
            }
        }
    }
}

