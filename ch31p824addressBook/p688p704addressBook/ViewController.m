

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface ViewController () <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate, ABPersonViewControllerDelegate>

@end

@implementation ViewController {
    BOOL _authDone;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Address Book Examples";
}

// run all examples on device

// modify this example so you'll actually get some results! look in console for results

/*
 As far as I can tell, ABAddressBookRequestAccessWithCompletion is useless.
 Here's why:
 (1) if this is a brand new app, there is no need to call ABAddressBookRequestAccessWithCompletion
 because authorization will be requested automatically anyway when we attempt access
 (2) if the user has denied access, ABAddressBookRequestAccessWithCompletion is a no-op!
 There is no way to make the dialog appear.
 (3) if all we want is to know whether we have access, ABAddressBookGetAuthorizationStatus tells us
 */

/*
 To test after the first time, Settings > General > Reset > Reset Location & Privacy
 Otherwise, the system somehow remembers the app even if you delete it
 */

/*
 NOTE Look in the info.plist to see the privacy message that will appear...
 ...as the second sentence of the alert
 */

/*
 Final note: if the user switches away from your app and changes a previously denied status
 to approve, your app is crashed in the background - deliberately - forcing it to start from scratch
 next time the user launches it
 Be prepared for this!
 */

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_authDone) {
        _authDone = YES;
        // ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        // if (status == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRef adbk = ABAddressBookCreateWithOptions(nil, nil);
            ABAddressBookRequestAccessWithCompletion(adbk,
                                                     ^(bool granted,
                                                       CFErrorRef error) {
                NSLog(@"%i %@", granted, adbk);
            });
        // }
    }
}

- (IBAction)doButton:(id)sender {
    // new iOS 6 feature: we can be refused access to address book
    // can check access beforehand
    ABAuthorizationStatus stat = ABAddressBookGetAuthorizationStatus();
    if (stat==kABAuthorizationStatusDenied || stat==kABAuthorizationStatusRestricted) {
        NSLog(@"%@", @"no access");
        return;
    }
    
    // iOS 6 change: use "withOptions", not the plain vanilla Create
    // we can get a nil result and an error if, say, we have no access
    // (there are not, in fact, any options to pass at the moment)
    CFErrorRef err = nil;
    ABAddressBookRef adbk = ABAddressBookCreateWithOptions(nil, &err);
    if (nil == adbk) {
        NSLog(@"error: %@", err);
        return;
    }
    
    ABRecordRef moi = nil;
    CFArrayRef matts = ABAddressBookCopyPeopleWithName(adbk, (CFStringRef)@"Matt");
    // might be multiple matts, but let's find the one with last name Neuburg
    for (CFIndex ix = 0; ix < CFArrayGetCount(matts); ix++) {
        ABRecordRef matt = CFArrayGetValueAtIndex(matts, ix);
        CFStringRef last = ABRecordCopyValue(matt, kABPersonLastNameProperty);
        if (last && CFStringCompare(last, (CFStringRef)@"Neuburg", 0) == 0)
            moi = matt;
        if (last) CFRelease(last);
    }
    if (nil == moi) {
        NSLog(@"Couldn't find myself");
        if (matts) CFRelease(matts);
        if (adbk) CFRelease(adbk);
        return;
    }
    // parse my emails
    ABMultiValueRef emails = ABRecordCopyValue(moi, kABPersonEmailProperty);
    for (CFIndex ix = 0; ix < ABMultiValueGetCount(emails); ix++) {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(emails, ix);
        CFStringRef value = ABMultiValueCopyValueAtIndex(emails, ix);
        NSLog(@"I have a %@ address: %@", label, value);
        if (label) CFRelease(label);
        if (value) CFRelease(value);
    }
    if (emails) CFRelease(emails);
    if (matts) CFRelease(matts);
    if (adbk) CFRelease(adbk);
}

// look in Contacts app afterwards to see that Snidely now exists

- (IBAction)doButton2:(id)sender {
    
    ABAuthorizationStatus stat = ABAddressBookGetAuthorizationStatus();
    if (stat==kABAuthorizationStatusDenied || stat==kABAuthorizationStatusRestricted) {
        NSLog(@"%@", @"no access");
        return;
    }
    CFErrorRef err = nil;
    ABAddressBookRef adbk = ABAddressBookCreateWithOptions(nil, &err);
    if (nil == adbk) {
        NSLog(@"error: %@", err);
        return;
    }
    
    ABRecordRef snidely = ABPersonCreate();
    ABRecordSetValue(snidely, kABPersonFirstNameProperty, @"Snidely", nil);
    ABRecordSetValue(snidely, kABPersonLastNameProperty, @"Whiplash", nil);
    ABMutableMultiValueRef addr = ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(addr, @"snidely@villains.com", kABHomeLabel, nil);
    ABRecordSetValue(snidely, kABPersonEmailProperty, addr, nil);
    ABAddressBookAddRecord(adbk, snidely, nil);
    ABAddressBookSave(adbk, nil);
    if (addr) CFRelease(addr);
    if (snidely) CFRelease(snidely);
    if (adbk) CFRelease(adbk);
    
}

// look in console to see result

- (IBAction)doButton3:(id)sender {
    ABPeoplePickerNavigationController* picker = 
    [ABPeoplePickerNavigationController new];
    picker.peoplePickerDelegate = self; // note: not merely "delegate"
    picker.displayedProperties = @[@(kABPersonEmailProperty)];
    [self presentViewController:picker animated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef emails = ABRecordCopyValue(person, property);
    CFIndex ix = ABMultiValueGetIndexForIdentifier(emails, identifier);
    CFStringRef email = ABMultiValueCopyValueAtIndex(emails, ix);
    NSLog(@"%@", email); // do something with the email here
    if (email) CFRelease(email);
    if (emails) CFRelease(emails);
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//


- (IBAction)doViewPerson:(id)sender {
    
    
    CFErrorRef err = nil;
    ABAddressBookRef adbk = ABAddressBookCreateWithOptions(nil, &err);
    if (nil == adbk) {
        NSLog(@"error: %@", err);
        return;
    }
    CFArrayRef snides = ABAddressBookCopyPeopleWithName(adbk, (CFStringRef)@"Snidely Whiplash");
    if (CFArrayGetCount(snides) < 1) {
        NSLog(@"%@", @"No Snidely!");
        return;
    }
    ABRecordRef snidely = CFArrayGetValueAtIndex(snides, 0);
    ABPersonViewController* pvc = [ABPersonViewController new];
    pvc.displayedPerson = snidely;
    pvc.personViewDelegate = self;
    pvc.allowsEditing = YES;
    pvc.allowsActions = YES;
    [self.navigationController pushViewController:pvc animated:YES];
    if (snides) CFRelease(snides);
    if (adbk) CFRelease(adbk);

}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

//

- (IBAction)doButton4:(id)sender {
    ABNewPersonViewController* npvc = [ABNewPersonViewController new];
    npvc.newPersonViewDelegate = self;
    UINavigationController* nc = 
    [[UINavigationController alloc] initWithRootViewController:npvc];
    [self presentViewController:nc animated:YES completion:nil];
}

// look in console for result; new person is created but not permanently added to user's address book

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    if (nil != person) {
        // if we didn't have access, we wouldn't be here!
        ABAddressBookRef adbk = ABAddressBookCreateWithOptions(nil, nil);
        // if we do not delete the person, the person will stay in the contacts database automatically!
        ABAddressBookRemoveRecord(adbk, person, nil);
        ABAddressBookSave(adbk, nil);
        CFStringRef name = ABRecordCopyCompositeName(person);
        NSLog(@"I have a person named %@, but I am not saving this person to the database", name); 
        // do something with new person
        if (name) CFRelease(name);
        if (adbk) CFRelease(adbk);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doButtonUnknownPerson:(id)sender {
    ABUnknownPersonViewController* unk = [ABUnknownPersonViewController new];
    unk.alternateName = @"Johnny Appleseed";
    unk.message = @"Person who really knows trees";
    unk.allowsAddingToAddressBook = YES;
    unk.allowsActions = YES;
    ABRecordRef person = ABPersonCreate();
    ABMutableMultiValueRef addr = ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(addr, @"johnny@seeds.com", kABHomeLabel, nil);
    ABRecordSetValue(person, kABPersonEmailProperty, addr, nil);
    unk.displayedPerson = person;
    unk.unknownPersonViewDelegate = self;
    [self.navigationController pushViewController:unk animated:YES];
    if (person) CFRelease(person);
    if (addr) CFRelease(addr);
}

-(void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person {
    NSLog(@"%@", person);
}


@end
