

#import "ViewController.h"
@import AddressBook;
@import AddressBookUI;

@interface ViewController () <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate, ABPersonViewControllerDelegate>

@property (nonatomic, strong) id adbk;
@end

@implementation ViewController {
    BOOL _authDone;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self->_authDone) {
        self->_authDone = YES;
        ABAuthorizationStatus stat = ABAddressBookGetAuthorizationStatus();
        switch (stat) {
            case kABAuthorizationStatusDenied:
            case kABAuthorizationStatusRestricted: {
                NSLog(@"%@", @"no access");
                break;
            }
            case kABAuthorizationStatusAuthorized:
            case kABAuthorizationStatusNotDetermined: {
                CFErrorRef err = nil;
                ABAddressBookRef adbk = ABAddressBookCreateWithOptions(nil, &err);
                if (nil == adbk) {
                    NSLog(@"error: %@", err);
                    return;
                }
                ABAddressBookRequestAccessWithCompletion
                (adbk, ^(bool granted, CFErrorRef error) {
                    if (granted)
                        self.adbk = CFBridgingRelease(adbk);
                    else
                        NSLog(@"error: %@", error);
                });
            }
        }
    }
}

- (IBAction)doFindMoi:(id)sender {
    ABAddressBookRef adbk = (__bridge ABAddressBookRef)self.adbk;
    if (!adbk)
        return;

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
}

- (IBAction) doCreateSnidely: (id) sender {
    ABAddressBookRef adbk = (__bridge ABAddressBookRef)self.adbk;
    if (!adbk)
        return;
    
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

}

// ===============

- (IBAction)doPeoplePicker:(id)sender {
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

// ===============

- (IBAction)doViewPerson:(id)sender {
    
    
    ABAddressBookRef adbk = (__bridge ABAddressBookRef)self.adbk;
    if (!adbk)
        return;

    CFArrayRef snides = ABAddressBookCopyPeopleWithName(adbk, (CFStringRef)@"Snidely Whiplash");
    if (CFArrayGetCount(snides) < 1) {
        NSLog(@"%@", @"No Snidely!");
        if (snides) CFRelease(snides);
        return;
    }
    ABRecordRef snidely = CFArrayGetValueAtIndex(snides, 0);
    ABPersonViewController* pvc = [ABPersonViewController new];
    pvc.addressBook = adbk;
    pvc.displayedPerson = snidely;
    pvc.personViewDelegate = self;
    pvc.displayedProperties = @[@(kABPersonEmailProperty)];
    pvc.allowsEditing = NO;
    pvc.allowsActions = NO;
    [self.navigationController pushViewController:pvc animated:YES];
    if (snides) CFRelease(snides);
    
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

// ============================================

- (IBAction)doNewPerson:(id)sender {
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
        ABAddressBookRef adbk = (__bridge ABAddressBookRef)self.adbk;
        // if we do not delete the person, the person will stay in the contacts database automatically!
        ABAddressBookRemoveRecord(adbk, person, nil);
        ABAddressBookSave(adbk, nil);
        CFStringRef name = ABRecordCopyCompositeName(person);
        NSLog(@"I have a person named %@, but I am not saving this person to the database", name);
        // do something with new person
        if (name) CFRelease(name);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ===========================================

- (IBAction)doUnknownPerson:(id)sender {
    ABUnknownPersonViewController* unk = [ABUnknownPersonViewController new];
    unk.message = @"Person who really knows trees";
    unk.allowsAddingToAddressBook = YES;
    unk.allowsActions = YES;
    ABRecordRef person = ABPersonCreate();
    ABRecordSetValue(person, kABPersonFirstNameProperty, @"Johnny", nil);
    ABRecordSetValue(person, kABPersonLastNameProperty, @"Appleseed", nil);
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
