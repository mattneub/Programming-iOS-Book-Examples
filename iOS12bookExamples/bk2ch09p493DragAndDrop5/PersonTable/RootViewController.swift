

import UIKit
import MobileCoreServices
import Contacts

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


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
}

extension Person : NSItemProviderWriting {
    
    // this means that a Person can be dragged to where a string is expected
    static var writableTypeIdentifiersForItemProvider =
        ["neuburg.matt.person", kUTTypeUTF8PlainText as String]
    
    func loadData(withTypeIdentifier typeid: String, forItemProviderCompletionHandler ch: @escaping (Data?, Error?) -> Void) -> Progress? {
        switch typeid {
        case "neuburg.matt.person":
            do {
                ch(try PropertyListEncoder().encode(self), nil)
            } catch {
                ch(nil, error)
            }
        case kUTTypeUTF8PlainText as NSString as String:
            ch(self.description.data(using: .utf8), nil)
        default: ch(nil, MyError.oops)
        }
        return nil
    }
}

extension Person : NSItemProviderReading {
    
    // this means that a string can be dragged to where a Person is expected
    static var readableTypeIdentifiersForItemProvider = ["neuburg.matt.person", kUTTypeVCard as String, kUTTypeUTF8PlainText as String]
    
    static func object(withItemProviderData data: Data, typeIdentifier typeid: String) throws -> Self {
        switch typeid {
        case "neuburg.matt.person":
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


class RootViewController: UITableViewController {
    
    struct Section {
        var sectionName : String
        var rowData : [Person]
    }
    var sections : [Section]!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let persons = [Person(firstName: "Matt", lastName: "Neuburg")]
        let section = Section(sectionName: "", rowData: persons)
        self.sections = [section]
        
        self.tableView.dropDelegate = self

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rowData.count
    }
    let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let person = self.sections[indexPath.section].rowData[indexPath.row]
        let name = person.firstName + " " + person.lastName
        cell.textLabel?.text = name
        return cell
    }
}

extension RootViewController : UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath ip: IndexPath?) -> UITableViewDropProposal {
        if ip == nil {
            return UITableViewDropProposal(operation: .cancel)
        }
        if !session.canLoadObjects(ofClass: Person.self) {
            return UITableViewDropProposal(operation: .cancel)
        }
        return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coord: UITableViewDropCoordinator) {
        var which : Int { return 1 }
        switch which {
        case 1:
            if let ip = coord.destinationIndexPath {
                coord.session.loadObjects(ofClass: Person.self) { persons in
                    for person in (persons as! [Person]).reversed() {
                        tableView.performBatchUpdates({
                            self.sections[ip.section].rowData.insert(person, at: ip.row)
                            tableView.insertRows(at: [ip], with: .none)
                        })
                    }
                }
            }
        case 2:
            guard let ip = coord.destinationIndexPath else {return}
            for item in coord.items {
                let item = item.dragItem
                guard item.itemProvider.canLoadObject(ofClass: Person.self) else {continue}
                let ph = UITableViewDropPlaceholder(
                    insertionIndexPath: ip,
                    reuseIdentifier: self.cellID,
                    rowHeight: self.tableView.rowHeight)
                ph.cellUpdateHandler = { cell in
                    cell.textLabel?.text = "" // "Placeholder"
                }
                print("dropping to placeholder")
                let con = coord.drop(item, to: ph)
                print("about to load object")
                item.itemProvider.loadObject(ofClass: Person.self) { p, err in
                    DispatchQueue.main.async {
                        // uncomment to see actual sequence of events unfold in so-mo
                        // delay(2) {
                        guard let p = p as? Person else {
                            con.deletePlaceholder()
                            return
                        }
                        print("object loaded, committing insertion")
                        con.commitInsertion(dataSourceUpdates: {ip in
                            tableView.performBatchUpdates({
                                self.sections[ip.section].rowData.insert(p, at: ip.row)
                            })
                        })
                        // }
                    }
                }
            }
        default: break
        }
    }
}
