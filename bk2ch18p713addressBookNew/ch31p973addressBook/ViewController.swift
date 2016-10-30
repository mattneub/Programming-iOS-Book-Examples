
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
                        let pred = CNContact.predicateForContacts(matchingName:"Matt")
                        var matts = try CNContactStore().unifiedContacts(matching:pred, keysToFetch: [
                            CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                            ])
                        matts = matts.filter{$0.familyName == "Neuburg"}
                        guard let moi = matts.first else {
                            print("couldn't find myself")
                            return
                        }
                        premoi = moi
                    case 2:
                        let pred = CNContact.predicateForContacts(matchingName:"Matt")
                        let req = CNContactFetchRequest(keysToFetch: [
                            CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                            ])
                        req.predicate = pred
                        var matt : CNContact? = nil
                        try CNContactStore().enumerateContacts(with:req) {
                            con, stop in
                            if con.familyName == "Neuburg" {
                                matt = con
                                stop.pointee = true
                            }
                        }
                        guard let moi = matt else {
                            print("couldn't find myself")
                            return
                        }
                        premoi = moi
                    default:break
                    }
                    var moi = premoi!
                    print(moi)
                    if moi.isKeyAvailable(CNContactEmailAddressesKey) {
                        print(moi.emailAddresses)
                    } else {
                        print("you haven't fetched emails yet")
                    }
                    moi = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
                    let emails = moi.emailAddresses
                    let workemails = emails.filter{$0.label == CNLabelWork}.map{$0.value}
                    print(workemails)
                    let full = CNContactFormatterStyle.fullName
                    let keys = CNContactFormatter.descriptorForRequiredKeys(for:full)
                    moi = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [keys, CNContactEmailAddressesKey as CNKeyDescriptor])
                    if let name = CNContactFormatter.string(from: moi, style: full) {
                        print("\(name): \(workemails[0])") // Matt Neuburg: matt@tidbits.com
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    
    @IBAction func doCreateSnidely (_ sender: Any!) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let snidely = CNMutableContact()
                    snidely.givenName = "Snidely"
                    snidely.familyName = "Whiplash"
                    let email = CNLabeledValue(label: CNLabelHome, value: "snidely@villains.com" as NSString)
                    snidely.emailAddresses.append(email)
                    snidely.imageData = UIImagePNGRepresentation(UIImage(named:"snidely")!)
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

    @IBAction func doPeoplePicker (_ sender: Any!) {
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
    }


    @IBAction func doViewPerson (_ sender: Any!) {
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
                    let pred = CNContact.predicateForContacts(matchingName: "Snidely")
                    let keys = CNContactViewController.descriptorForRequiredKeys()
                    let snides = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: [keys])
                    guard let snide1 = snides.first else {
                        print("no snidely")
                        return
                    }
                    snide = snide1
                    let d = NSKeyedArchiver.archivedData(withRootObject: snide)
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
                    if let snide1 = NSKeyedUnarchiver.unarchiveObject(with: d) as? CNContact {
                        snide = snide1
                    }
                }
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

    @IBAction func doNewPerson (_ sender: Any!) {
        let con = CNMutableContact()
        con.givenName = "Dudley"
        con.familyName = "Doright"
        let npvc = CNContactViewController(forNewContact: con)
        npvc.delegate = self
        self.present(UINavigationController(rootViewController: npvc), animated:true)
    }
    
    @IBAction func doUnknownPerson (_ sender: Any!) {
        let con = CNMutableContact()
        con.givenName = "Johnny"
        con.familyName = "Appleseed"
        con.phoneNumbers.append(CNLabeledValue(label: "woods", value: CNPhoneNumber(stringValue: "555-123-4567")))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = true
        // unkvc.displayedPropertyKeys = []
        self.navigationController?.pushViewController(unkvc, animated: true)
    }



}

