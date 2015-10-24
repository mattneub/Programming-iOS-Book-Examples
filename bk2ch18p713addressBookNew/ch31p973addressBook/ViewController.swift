
import UIKit
import Contacts
import ContactsUI


func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    // authorization
    
    func determineStatus() -> Bool {
        let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            CNContactStore().requestAccessForEntityType(.Contacts) {_ in}
            return false
        case .Restricted:
            return false
        case .Denied:
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Contacts?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    //
    
    @IBAction func doFindMoi (sender:AnyObject!) {
        CNContactStore().requestAccessForEntityType(.Contacts) {
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
                    let pred = CNContact.predicateForContactsMatchingName("Matt")
                    var matts = try CNContactStore().unifiedContactsMatchingPredicate(pred, keysToFetch: [
                        CNContactFamilyNameKey, CNContactGivenNameKey
                        ])
                    matts = matts.filter{$0.familyName == "Neuburg"}
                    guard var moi = matts.first else {
                        print("couldn't find myself")
                        return
                    }
                    premoi = moi
                case 2:
                    let pred = CNContact.predicateForContactsMatchingName("Matt")
                    let req = CNContactFetchRequest(keysToFetch: [
                        CNContactFamilyNameKey, CNContactGivenNameKey
                        ])
                    req.predicate = pred
                    var matt : CNContact? = nil
                    try CNContactStore().enumerateContactsWithFetchRequest(req) {
                        con, stop in
                        if con.familyName == "Neuburg" {
                            matt = con
                            stop.memory = true
                        }
                    }
                    guard var moi = matt else {
                        print("couldn't find myself")
                        return
                    }
                    premoi = moi
                default:break
                }
                var moi = premoi
                print(moi)
                if moi.isKeyAvailable(CNContactEmailAddressesKey) {
                    print(moi.emailAddresses)
                } else {
                    print("you haven't fetched emails yet")
                }
                moi = try CNContactStore().unifiedContactWithIdentifier(moi.identifier, keysToFetch: [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactEmailAddressesKey])
                let emails = moi.emailAddresses
                let workemails = emails.filter{$0.label == CNLabelWork}.map{$0.value}
                print(workemails)
                let full = CNContactFormatterStyle.FullName
                let keys = CNContactFormatter.descriptorForRequiredKeysForStyle(full)
                moi = try CNContactStore().unifiedContactWithIdentifier(moi.identifier, keysToFetch: [keys, CNContactEmailAddressesKey])
                if let name = CNContactFormatter.stringFromContact(moi, style: full) {
                    print("\(name): \(workemails[0])") // Matt Neuburg: matt@tidbits.com
                }
            } catch {
                print(error)
            }
        }
    }

    
    @IBAction func doCreateSnidely (sender:AnyObject!) {
        let snidely = CNMutableContact()
        snidely.givenName = "Snidely"
        snidely.familyName = "Whiplash"
        let email = CNLabeledValue(label: CNLabelHome, value: "snidely@villains.com")
        snidely.emailAddresses.append(email)
        snidely.imageData = UIImagePNGRepresentation(UIImage(named:"snidely.jpg")!)
        let save = CNSaveRequest()
        save.addContact(snidely, toContainerWithIdentifier: nil)
        CNContactStore().requestAccessForEntityType(.Contacts) {
            ok, error in
            guard ok else {
                print("not authorized")
                return
            }
            do {
                try CNContactStore().executeSaveRequest(save)
                print("created snidely!")
            } catch {
                print(error)
            }
        }
    }

    @IBAction func doPeoplePicker (sender:AnyObject!) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactEmailAddressesKey]
        picker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'emailAddresses'")
        picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        self.presentViewController(picker, animated:true, completion:nil)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty prop: CNContactProperty) {
        print(prop)
        print(prop.contact)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doViewPerson (sender:AnyObject!) {
        
        CNContactStore().requestAccessForEntityType(.Contacts) {
            ok, err in
            guard ok else {
                print("not authorized")
                return
            }
            do {
                let pred = CNContact.predicateForContactsMatchingName("Snidely")
                let keys = CNContactViewController.descriptorForRequiredKeys()
                let snides = try CNContactStore().unifiedContactsMatchingPredicate(pred, keysToFetch: [keys])
                guard let snide = snides.first else {
                    print("no snidely")
                    return
                }
                let vc = CNContactViewController(forContact:snide)
                vc.delegate = self
                vc.message = "Nyah ah ahhh"
                vc.allowsActions = false
                vc.contactStore = CNContactStore()
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } catch {
                print(error)
            }
        }
    }

    func contactViewController(vc: CNContactViewController, didCompleteWithContact con: CNContact?) {
        print(con)
    }
    
    func contactViewController(vc: CNContactViewController, shouldPerformDefaultActionForContactProperty prop: CNContactProperty) -> Bool {
        return false
    }

    @IBAction func doNewPerson (sender:AnyObject!) {
        let con = CNMutableContact()
        con.givenName = "Dudley"
        con.familyName = "Doright"
        let npvc = CNContactViewController(forNewContact: con)
        npvc.delegate = self
        self.presentViewController(UINavigationController(rootViewController: npvc), animated: true, completion:nil)
    }
    
    @IBAction func doUnknownPerson (sender:AnyObject!) {
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
        // self.presentViewController(UINavigationController(rootViewController: unkvc), animated:true, completion:nil)
        // and this doesn't work either!
        // self.presentViewController(unkvc, animated:true, completion:nil)
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
    
    @IBAction func doNewPerson (sender:AnyObject!) {
        let npvc = ABNewPersonViewController()
        npvc.newPersonViewDelegate = self
        let nc = UINavigationController(rootViewController:npvc)
        self.presentViewController(nc, animated:true, completion:nil)
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
            self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    // =========
    
    @IBAction func doUnknownPerson (sender:AnyObject!) {
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

