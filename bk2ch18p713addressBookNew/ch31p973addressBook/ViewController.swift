
import UIKit
import Contacts
import ContactsUI


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController : UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    // authorization
    
    @discardableResult
    func determineStatus() -> Bool {
        let status = CNContactStore.authorizationStatus(for:.contacts)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            CNContactStore().requestAccess(for:.contacts) {_ in}
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Contacts?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                _ in
                let url = URL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(url)
            })
            self.present(alert, animated:true)
            return false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(determineStatus), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    //
    
    @IBAction func doFindMoi (_ sender:AnyObject!) {
        CNContactStore().requestAccess(for:.contacts) {
            ok, err in
            guard ok else {
                print("not authorized")
                return
            }
            var which : Int {return 2} // 1 or 2
            do {
                var premoi : CNContact!
                switch which {
                case 1:
                    let pred = CNContact.predicateForContacts(matchingName:"Matt")
                    var matts = try CNContactStore().unifiedContacts(matching:pred, keysToFetch: [
                        CNContactFamilyNameKey, CNContactGivenNameKey
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
                        CNContactFamilyNameKey, CNContactGivenNameKey
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
                moi = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactEmailAddressesKey])
                let emails = moi.emailAddresses
                let workemails = emails.filter{$0.label == CNLabelWork}.map{$0.value}
                print(workemails)
                let full = CNContactFormatterStyle.fullName
                let keys = CNContactFormatter.descriptorForRequiredKeys(for:full)
                moi = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [keys, CNContactEmailAddressesKey])
                if let name = CNContactFormatter.string(from: moi, style: full) {
                    print("\(name): \(workemails[0])") // Matt Neuburg: matt@tidbits.com
                }
            } catch {
                print(error)
            }
        }
    }

    
    @IBAction func doCreateSnidely (_ sender:AnyObject!) {
        let snidely = CNMutableContact()
        snidely.givenName = "Snidely"
        snidely.familyName = "Whiplash"
        let email = CNLabeledValue(label: CNLabelHome, value: "snidely@villains.com")
        snidely.emailAddresses.append(email)
        snidely.imageData = UIImagePNGRepresentation(UIImage(named:"snidely.jpg")!)
        let save = CNSaveRequest()
        save.add(snidely, toContainerWithIdentifier: nil)
        CNContactStore().requestAccess(for:.contacts) {
            ok, error in
            guard ok else {
                print("not authorized")
                return
            }
            do {
                try CNContactStore().execute(save)
                print("created snidely!")
            } catch {
                print(error)
            }
        }
    }

    @IBAction func doPeoplePicker (_ sender:AnyObject!) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactEmailAddressesKey]
        picker.predicateForSelectionOfProperty = Predicate(format: "key == 'emailAddresses'")
        picker.predicateForEnablingContact = Predicate(format: "emailAddresses.@count > 0")
        self.present(picker, animated:true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect prop: CNContactProperty) {
        print(prop)
        print(prop.contact)
        self.dismiss(animated:true)
    }

    @IBAction func doViewPerson (_ sender:AnyObject!) {
        
        CNContactStore().requestAccess(for: .contacts) {
            ok, err in
            guard ok else {
                print("not authorized")
                return
            }
            do {
                let pred = CNContact.predicateForContacts(matchingName: "Snidely")
                let keys = CNContactViewController.descriptorForRequiredKeys()
                let snides = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: [keys])
                guard let snide = snides.first else {
                    print("no snidely")
                    return
                }
                let vc = CNContactViewController(for:snide)
                vc.delegate = self
                vc.message = "Nyah ah ahhh"
                vc.allowsActions = false
                vc.contactStore = CNContactStore()
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } catch {
                print(error)
            }
        }
    }

    func contactViewController(_ vc: CNContactViewController, didCompleteWith con: CNContact?) {
        print(con)
    }
    
    func contactViewController(_ vc: CNContactViewController, shouldPerformDefaultActionFor prop: CNContactProperty) -> Bool {
        return false
    }

    @IBAction func doNewPerson (_ sender:AnyObject!) {
        let con = CNMutableContact()
        con.givenName = "Dudley"
        con.familyName = "Doright"
        let npvc = CNContactViewController(forNewContact: con)
        npvc.delegate = self
        self.present(UINavigationController(rootViewController: npvc), animated: true)
    }
    
    @IBAction func doUnknownPerson (_ sender:AnyObject!) {
        let con = CNMutableContact()
        con.givenName = "Johnny"
        con.familyName = "Appleseed"
        con.phoneNumbers.append(CNLabeledValue(label: "woods", value: CNPhoneNumber(stringValue: "555-123-4567")))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
        // this doesn't work either
        // self.present(UINavigationController(rootViewController: unkvc), animated:true)
        // and this doesn't work either!
        // self.present(unkvc, animated:true)
    }



}

/*

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate {




    // =========
    
    @IBAction func doNewPerson (_ sender:AnyObject!) {
        let npvc = ABNewPersonViewController()
        npvc.newPersonViewDelegate = self
        let nc = UINavigationController(rootViewController:npvc)
        self.present(nc, animated:true)
    }
    

    func newPersonViewController(newPersonView: ABNewPersonViewController, didCompleteWithNewPerson person: ABRecord?) {
            if person != nil {
                // if we didn't have access, we wouldn't be here!
                // if we do not delete the person, the person will stay in the contacts database automatically!
                ABAddressBookRemoveRecord(self.adbk, person, nil)
                ABAddressBookSave(self.adbk, nil)
                let name = ABRecordCopyCompositeName(person).takeRetainedValue()
                print("I have a person named \(name), not saving this person to the database")
                // do something with new person
            }
            self.dismiss(animated:true)
    }
    
    // =========
    
    @IBAction func doUnknownPerson (_ sender:AnyObject!) {
        let unk = ABUnknownPersonViewController()
        unk.message = "Person who really knows trees"
        unk.allowsAddingToAddressBook = true
        unk.allowsActions = true // user can tap an email address to switch to mail, for example
        let person:ABRecord = ABPersonCreate().takeRetainedValue()
        ABRecordSetValue(person, kABPersonFirstNameProperty, "Johnny", nil)
        ABRecordSetValue(person, kABPersonLastNameProperty, "Appleseed", nil)
        let addr:ABMutableMultiValue = ABMultiValueCreateMutable(
            ABPropertyType(kABStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(addr, "johnny@seeds.com", kABHomeLabel, nil)
        ABRecordSetValue(person, kABPersonEmailProperty, addr, nil)
        unk.displayedPerson = person
        unk.unknownPersonViewDelegate = self
        self.showViewController(unk, sender:self) // push onto navigation controller
    }

    func unknownPersonViewController(
        unknownCardViewController: ABUnknownPersonViewController,
        didResolveToPerson person: ABRecord?) {
            if let person:ABRecord = person {
                let name = ABRecordCopyCompositeName(person).takeRetainedValue()
                print("user did something with \(name)") // only implementing this to shut the compiler up
            }
    }
    
    
}

*/

