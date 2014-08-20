
import UIKit
import AddressBook
import AddressBookUI

class ViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate {

    // note: if the contacts change behind your back while your app is open...
    // your retained address book will go out of date
    // unfortunately the way around that is to register an external change callback...
    // ...and you can't do that using Swift alone
    var adbk : ABAddressBook!
    var authDone = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.authDone {
            self.authDone = true
            let stat = ABAddressBookGetAuthorizationStatus()
            switch stat {
            case .Denied, .Restricted:
                println("no access")
            case .Authorized, .NotDetermined:
                var err : Unmanaged<CFError>? = nil
                let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
                if adbk == nil {
                    println(err)
                    return
                }
                ABAddressBookRequestAccessWithCompletion(adbk) {
                    (granted:Bool, err:CFError!) in
                    if granted {
                        self.adbk = adbk
                    } else {
                        println(err)
                    }
                }
            }
        }
    }
    
    @IBAction func doFindMoi (sender:AnyObject!) {
        
        if adbk == nil {
            println("no access")
            return
        }
        
        var moi : ABRecord! = nil
        let matts = ABAddressBookCopyPeopleWithName(adbk, "Matt").takeRetainedValue() as NSArray
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
            println("couldn't find myself")
            return
        }
        // parse my emails
        let emails:ABMultiValue = ABRecordCopyValue(
            moi, kABPersonEmailProperty).takeRetainedValue() as ABMultiValue
        for ix in 0 ..< ABMultiValueGetCount(emails) {
            let label = ABMultiValueCopyLabelAtIndex(emails,ix).takeRetainedValue() as NSString
            let value = ABMultiValueCopyValueAtIndex(emails,ix).takeRetainedValue() as NSString
            println("I have a \(label) address: \(value)")
        }
    }

    @IBAction func doCreateSnidely (sender:AnyObject!) {
        if adbk == nil {
            println("no access")
            return
        }

        let snidely:ABRecord = ABPersonCreate().takeRetainedValue()
        ABRecordSetValue(snidely, kABPersonFirstNameProperty, "Snidely", nil)
        ABRecordSetValue(snidely, kABPersonLastNameProperty, "Whiplash", nil)
        let addr:ABMutableMultiValue = ABMultiValueCreateMutable(
            ABPropertyType(kABStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(addr, "snidely@villains.com", kABHomeLabel, nil)
        ABRecordSetValue(snidely, kABPersonEmailProperty, addr, nil)
        ABAddressBookAddRecord(adbk, snidely, nil)
        ABAddressBookSave(adbk, nil)
    }
    
    // ============
    
    @IBAction func doPeoplePicker (sender:AnyObject!) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties = [Int(kABPersonEmailProperty)]
        // new iOS 8 features: instead of delegate "continueAfter" methods
        picker.predicateForSelectionOfPerson = NSPredicate(value:false) // display additional info for all persons
        picker.predicateForSelectionOfProperty = NSPredicate(value:true) // call delegate method for all properties
        self.presentViewController(picker, animated:true, completion:nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!,
        didSelectPerson person: ABRecordRef!,
        property: ABPropertyID,
        identifier: ABMultiValueIdentifier) {
            let emails : ABMultiValue = ABRecordCopyValue(person, property).takeRetainedValue()
            let ix = ABMultiValueGetIndexForIdentifier(emails, identifier)
            let email = ABMultiValueCopyValueAtIndex(emails, ix).takeRetainedValue() as NSString
            println(email) // do something with the email here
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // =========
    
    @IBAction func doViewPerson (sender:AnyObject!) {
        if adbk == nil {
            println("no access")
            return
        }

        let snides = ABAddressBookCopyPeopleWithName(
            adbk, "Snidely Whiplash").takeRetainedValue() as NSArray as Array<ABRecord>
        if snides.count == 0 {
            println("no Snidely")
            return
        }
        let snidely:ABRecord = snides[0]
        let pvc = ABPersonViewController()
        pvc.addressBook = adbk
        pvc.displayedPerson = snidely
        pvc.personViewDelegate = self
        pvc.displayedProperties = [Int(kABPersonEmailProperty)]
        pvc.allowsEditing = false
        pvc.allowsActions = false
        self.showViewController(pvc, sender:self) // push onto navigation controller
    }
    
    func personViewController(personViewController: ABPersonViewController!,
        shouldPerformDefaultActionForPerson person: ABRecord!,
        property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
            return false // if true, email tap launches email etc.
    }

    // =========
    
    @IBAction func doNewPerson (sender:AnyObject!) {
        let npvc = ABNewPersonViewController()
        npvc.newPersonViewDelegate = self
        let nc = UINavigationController(rootViewController:npvc)
        self.presentViewController(nc, animated:true, completion:nil)
    }

    func newPersonViewController(newPersonView: ABNewPersonViewController!,
        didCompleteWithNewPerson person: ABRecord!) {
            if person != nil {
                // if we didn't have access, we wouldn't be here!
                // if we do not delete the person, the person will stay in the contacts database automatically!
                ABAddressBookRemoveRecord(adbk, person, nil)
                ABAddressBookSave(adbk, nil)
                let name = ABRecordCopyCompositeName(person).takeRetainedValue()
                println("I have a person named \(name), not saving this person to the database")
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
        unknownCardViewController: ABUnknownPersonViewController!,
        didResolveToPerson person: ABRecord!) {
            if let person:ABRecord = person {
                let name = ABRecordCopyCompositeName(person).takeRetainedValue()
                println("user did something with \(name)") // only implementing this to shut the compiler up
            }
    }
    
    
}

