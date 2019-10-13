
import UIKit
import Contacts
import ContactsUI


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func checkForContactsAccess(andThen f:(()->())? = nil) {
    let status = CNContactStore.authorizationStatus(for:.contacts)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        CNContactStore().requestAccess(for:.contacts) { ok, err in
            if ok {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        print("denied")
        break
    @unknown default: fatalError()
    }
}

class ViewController : UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ignore Me", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    //
    
    @IBAction func doFindMoi (_ sender: Any!) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                var which : Int {return 2} // 1 or 2
                do {
                    var premoi : CNContact!
                    switch which {
                    case 1:
                        let pred = CNContact.predicateForContacts(matchingName:"Matt Neuburg") // "Neuburg Matt" works too etc.
                        let matts = try CNContactStore().unifiedContacts(matching:pred, keysToFetch: [
                            CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                            ])
                        guard let moi = matts.first else {
                            print("couldn't find myself")
                            return
                        }
                        premoi = moi
                    case 2:
                        let pred = CNContact.predicateForContacts(matchingName:"Matt Neuburg")
                        let req = CNContactFetchRequest(keysToFetch: [
                            CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                            ])
                        req.predicate = pred
                        var matt : CNContact? = nil
                        try CNContactStore().enumerateContacts(with:req) { con, stop in
                            matt = con
                            stop.pointee = true
                        }
                        guard let moi = matt else {
                            print("couldn't find myself")
                            return
                        }
                        premoi = moi
                    default:break
                    }
                    let moi = premoi!
                    print(moi)
                    if moi.isKeyAvailable(CNContactEmailAddressesKey) {
                        print(moi.emailAddresses)
                    } else {
                        print("you haven't fetched emails yet")
                    }
                    let moi2 = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
                    let emails = moi2.emailAddresses
                    let workemails = emails.filter{$0.label == CNLabelWork}.map{$0.value}
                    print(workemails)
                    let full = CNContactFormatterStyle.fullName
                    let keys = CNContactFormatter.descriptorForRequiredKeys(for:full)
                    let moi3 = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [keys, CNContactEmailAddressesKey as CNKeyDescriptor])
                    if let name = CNContactFormatter.string(from: moi3, style: full) {
                        print("\(name): \(workemails[0])") // Matt Neuburg: matt@tidbits.com
                    }
                    
                    // new feature, let's see if I can find myself thru my email
                    let anemail = emails[0]
                    let pred2 = CNContact.predicateForContacts(matchingEmailAddress: anemail.value as String)
                    let moi4 = try CNContactStore().unifiedContacts(matching: pred2, keysToFetch: [CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor])
                    print(moi4)
                    
                    // intriguing: you can find the pieces of a physical address
                    do {
                        let pred = CNContact.predicateForContacts(matchingName:"Charlotte Wilson")
                        let c = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: [CNContactPostalAddressesKey as CNKeyDescriptor])[0]
                        let addr = c.postalAddresses[0]
                        let form = CNPostalAddressFormatter()
                        let attr = form.attributedString(from: addr.value, withDefaultAttributes: [:])
                        let s = attr.string as NSString
                        let range = NSRange(location: 0, length: s.length)
                        let key = NSAttributedString.Key(rawValue:CNPostalAddressPropertyAttribute)
                        attr.enumerateAttributes(in: range, options: []) { result, r, stop in
                            if let val = result[key] as? String {
                                if val == "country" {
                                    // r is the range of the country name
                                    print("country is:", s.substring(with: r))
                                    if let mas = attr.mutableCopy() as? NSMutableAttributedString {
                                        mas.addAttributes([.underlineStyle:NSUnderlineStyle.single.rawValue], range: r)
                                        print(mas)
                                        print(mas.string)
                                    }
                                    stop.pointee = true
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    
    @IBAction func doCreateSnidely (_ sender: Any) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let snidely = CNMutableContact()
                    snidely.givenName = "Snidely"
                    snidely.familyName = "Whiplash"
                    let email = CNLabeledValue(label: CNLabelHome, value: "snidely@villains.com" as NSString)
                    snidely.emailAddresses.append(email)
                    snidely.imageData = UIImage(named:"snidely")!.pngData()
                    let save = CNSaveRequest()
                    save.add(snidely, toContainerWithIdentifier: nil)
                    try CNContactStore().execute(save)
                    print("created snidely!")
                } catch {
                    print(error)
                }
            }
        }
    }

    @IBAction func doPeoplePicker (_ sender: Any) {
        // checkForContactsAccess {

        let picker = CNContactPickerViewController()
        picker.delegate = self
        do {
            picker.displayedPropertyKeys = [CNContactEmailAddressesKey]
//            picker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'emailAddresses'")
            picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
//            picker.predicateForSelectionOfContact = NSPredicate(format: "emailAddresses.@count > 0")
        }
        self.present(picker, animated:true)
            
        //}
    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect con: CNContact) {
//        print("con")
//        print(con)
//    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect prop: CNContactProperty) {
        print("prop")
        print(prop)
        print(prop.contact) // showing that it is fully populated
    }


    @IBAction func doViewPerson (_ sender: Any) {
        // let's do an experiment:
        // if we have authorization, get the contact from the database
        // if we don't, get it from user defaults
        // in this way, we discover whether the view controller can be used without authorization
        // hint: yes it can
        
        DispatchQueue.global(qos: .userInitiated).async {
            var snide : CNContact!
            let status = CNContactStore.authorizationStatus(for:.contacts)
            if status == .authorized {
                print("getting from store")
                do {
                    let pred = CNContact.predicateForContacts(matchingName: "Snidely Whiplash")
                    let keys = CNContactViewController.descriptorForRequiredKeys()
                    let snides = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: [keys])
                    guard let snide1 = snides.first else {
                        print("no snidely")
                        return
                    }
                    snide = snide1
                    let d = try NSKeyedArchiver.archivedData(withRootObject: snide!, requiringSecureCoding: true)
                    let ud = UserDefaults.standard
                    ud.set(d, forKey:"snide")
                } catch {
                    print (error)
                }
            }
            else {
                print("getting from defaults")
                let ud = UserDefaults.standard
                if let d = ud.object(forKey: "snide") as? Data {
                    if let snide1 = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CNContact.self, from: d) {
                        snide = snide1
                    }
                }
            }
            if snide == nil {
                print("you didn't do the experiment properly, snide is nil")
                return
            }
            
            let vc = CNContactViewController(for:snide)
            vc.delegate = self
            vc.message = "Nyah ah ahhh"
            vc.allowsActions = false
            //vc.highlightProperty(withKey: CNContactEmailAddressesKey, identifier: CNLabelHome)
            vc.contactStore = nil // no effect, can't prevent saving
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
    }

    func contactViewController(_ vc: CNContactViewController, didCompleteWith con: CNContact?) {
        print(con as Any)
        self.dismiss(animated: true) // needed for `forNewContact`, does no harm in the others
    }
    
    func contactViewController(_ vc: CNContactViewController, shouldPerformDefaultActionFor prop: CNContactProperty) -> Bool {
        print("tapped \(prop)")
        return false
    }

    @IBAction func doNewPerson (_ sender: Any) {
        let con = CNMutableContact()
        con.givenName = "Dudley"
        con.familyName = "Doright"
        // con.imageData = UIImage(named:"snidely")!.pngData() // works
        let npvc = CNContactViewController(forNewContact: con)
        npvc.delegate = self
        // but there's a bug in iOS 13; you can't dismiss the thing if the keyboard is showing
        let nav = UINavigationController(rootViewController: npvc)
        self.present(nav, animated:true)
    }
    
    @IBAction func doUnknownPerson (_ sender: Any) {
        let con = CNMutableContact()
        con.givenName = "Johnny"
        con.familyName = "Appleseed"
        con.phoneNumbers.append(CNLabeledValue(label: "woods", value: CNPhoneNumber(stringValue: "555-123-4567")))
        // con.imageData = UIImage(named:"snidely")!.pngData() // works
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = true
        // unkvc.displayedPropertyKeys = []
        unkvc.edgesForExtendedLayout = [] // yuck, try to prevent bug in iOS 13
        self.navigationController?.view.backgroundColor = .white // ditto
        self.navigationController?.pushViewController(unkvc, animated: true)
        // self.present(UINavigationController(rootViewController:unkvc), animated:true)
    }



}

