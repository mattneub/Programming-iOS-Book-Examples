
import UIKit
import AddressBook
import AddressBookUI

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
}


class ViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate {

    // note: if the contacts change behind your back while your app is open...
    // your retained address book will go out of date
    // unfortunately the way around that is to register an external change callback...
    // ...and you can't do that using Swift alone
    var adbk : ABAddressBook!
    
    func createAddressBook() -> Bool {
        if self.adbk != nil {
            return true
        }
        var err : Unmanaged<CFError>? = nil
        let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            print(err)
            self.adbk = nil
            return false
        }
        self.adbk = adbk
        return true
    }
    
    @discardableResult
    func determineStatus() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .authorized:
            return self.createAddressBook()
        case .notDetermined:
            var ok = false
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError?) in
                DispatchQueue.main.async {
                    if granted {
                        ok = self.createAddressBook()
                    }
                }
            }
            if ok == true {
                return true
            }
            self.adbk = nil
            return false
        case .restricted:
            self.adbk = nil
            return false
        case .denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Contacts?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                _ in
                let url = URL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared().open(url)
            })
            self.present(alert, animated:true)
            self.adbk = nil
            return false
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(determineStatus), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @IBAction func doFindMoi (_ sender:AnyObject!) {
        
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        var moi : ABRecord! = nil
        let matts = ABAddressBookCopyPeopleWithName(self.adbk, "Matt").takeRetainedValue() as [AnyObject]
        // could have asked for "Matt Neuburg" but I wanted to show how to cycle thru the results
        for matt in matts {
            if let last = ABRecordCopyValue(matt, kABPersonLastNameProperty).takeRetainedValue() as? String {
                if last == "Neuburg" {
                    moi = matt
                    break
                }
            }
        }
        if moi == nil {
            print("couldn't find myself")
            return
        }
        // parse my emails
        let emails:ABMultiValue = ABRecordCopyValue(
            moi, kABPersonEmailProperty).takeRetainedValue()
        for ix in 0 ..< ABMultiValueGetCount(emails) {
            let label = ABMultiValueCopyLabelAtIndex(emails,ix).takeRetainedValue() as String
            let value = ABMultiValueCopyValueAtIndex(emails,ix).takeRetainedValue() as! String
            print("I have a \(label) address: \(value)")
        }
    }

    @IBAction func doCreateSnidely (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let snidely:ABRecord = ABPersonCreate().takeRetainedValue()
        ABRecordSetValue(snidely, kABPersonFirstNameProperty, "Snidely", nil)
        ABRecordSetValue(snidely, kABPersonLastNameProperty, "Whiplash", nil)
        let addr:ABMultiValue = ABMultiValueCreateMutable(
            ABPropertyType(kABStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(addr, "snidely@villains.com", kABHomeLabel, nil)
        ABRecordSetValue(snidely, kABPersonEmailProperty, addr, nil)
        ABAddressBookAddRecord(self.adbk, snidely, nil)
        ABAddressBookSave(self.adbk, nil)
    }
    
    // ============
    
    @IBAction func doPeoplePicker (_ sender:AnyObject!) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties = [Int(kABPersonEmailProperty)]
        // new iOS 8 features: instead of delegate "continueAfter" methods
        // picker.predicateForEnablingPerson = NSPredicate(format: "%K like %@", ABPersonFamilyNameProperty, "Neuburg")
        picker.predicateForSelectionOfPerson = Predicate(value:false) // display additional info for all persons
        picker.predicateForSelectionOfProperty = Predicate(value:true) // call delegate method for all properties
        self.present(picker, animated:true)
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        print("person")
        print(person)
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController,
        didSelectPerson person: ABRecord,
        property: ABPropertyID,
        identifier: ABMultiValueIdentifier) {
            print("person and property")
//            print(person)
//            print(property)
//            return;
            if property != kABPersonEmailProperty {
                print("WTF") // shouldn't happen
                return
            }
            let emails:ABMultiValue = ABRecordCopyValue(person, property).takeRetainedValue()
            let ix = ABMultiValueGetIndexForIdentifier(emails, identifier)
            let email = ABMultiValueCopyValueAtIndex(emails, ix).takeRetainedValue() as! String
            print(email) // do something with the email here
            // self.dismiss(animated:true)
    }
    
    // =========
    
    @IBAction func doViewPerson (_ sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let snides = ABAddressBookCopyPeopleWithName(
            self.adbk, "Snidely Whiplash").takeRetainedValue() as [AnyObject]
        if snides.count == 0 {
            print("no Snidely")
            return
        }
        let snidely:ABRecord = snides[0]
        let pvc = ABPersonViewController()
        pvc.addressBook = self.adbk
        pvc.displayedPerson = snidely
        pvc.personViewDelegate = self
        pvc.displayedProperties = [Int(kABPersonEmailProperty)]
        pvc.allowsEditing = false
        pvc.allowsActions = false
        self.show(pvc, sender:self) // push onto navigation controller
    }
    
    func personViewController(_ personViewController: ABPersonViewController,
        shouldPerformDefaultActionForPerson person: ABRecord,
        property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
            return false // if true, email tap launches email etc.
    }

    // =========
    
    @IBAction func doNewPerson (_ sender:AnyObject!) {
        let npvc = ABNewPersonViewController()
        npvc.newPersonViewDelegate = self
        let nc = UINavigationController(rootViewController:npvc)
        self.present(nc, animated:true)
    }
    

    func newPersonViewController(_ newPersonView: ABNewPersonViewController, didCompleteWithNewPerson person: ABRecord?) {
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
        self.show(unk, sender:self) // push onto navigation controller
    }

    func unknownPersonViewController(
        _ unknownCardViewController: ABUnknownPersonViewController,
        didResolveToPerson person: ABRecord?) {
            if let person:ABRecord = person {
                let name = ABRecordCopyCompositeName(person).takeRetainedValue()
                print("user did something with \(name)") // only implementing this to shut the compiler up
            }
    }
    
    
}

