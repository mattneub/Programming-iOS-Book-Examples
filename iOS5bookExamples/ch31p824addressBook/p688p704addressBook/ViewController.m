

#import "ViewController.h"
#import <AddressBook/AddressBook.h>


@implementation ViewController

// run all examples on device

// modify this example so you'll actually get some results! look in console for results

- (IBAction)doButton:(id)sender {
    ABAddressBookRef adbk = ABAddressBookCreate();
    ABRecordRef moi = NULL;
    CFArrayRef matts = ABAddressBookCopyPeopleWithName(adbk, (CFStringRef)@"Matt");
    // might be multiple matts, but let's find the one with last name Neuburg
    for (CFIndex ix = 0; ix < CFArrayGetCount(matts); ix++) {
        ABRecordRef matt = CFArrayGetValueAtIndex(matts, ix);
        CFStringRef last = ABRecordCopyValue(matt, kABPersonLastNameProperty);
        if (last && CFStringCompare(last, (CFStringRef)@"Neuburg", 0) == 0)
            moi = matt;
        if (last)
            CFRelease(last);
    }
    if (NULL == moi) {
        NSLog(@"Couldn't find myself");
        CFRelease(matts);
        CFRelease(adbk);
        return;
    }
    // parse my emails
    ABMultiValueRef emails = ABRecordCopyValue(moi, kABPersonEmailProperty);
    for (CFIndex ix = 0; ix < ABMultiValueGetCount(emails); ix++) {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(emails, ix);
        CFStringRef value = ABMultiValueCopyValueAtIndex(emails, ix);
        NSLog(@"I have a %@ address: %@", label, value);
        CFRelease(label);
        CFRelease(value);
    }
    CFRelease(emails);
    CFRelease(matts);
    CFRelease(adbk);
}

// look in Contacts app afterwards to see that Snidely now exists

- (IBAction)doButton2:(id)sender {
    ABAddressBookRef adbk = ABAddressBookCreate();
    ABRecordRef snidely = ABPersonCreate();
    ABRecordSetValue(snidely, kABPersonFirstNameProperty, @"Snidely", NULL);
    ABRecordSetValue(snidely, kABPersonLastNameProperty, @"Whiplash", NULL);
    ABMutableMultiValueRef addr = ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(addr, @"snidely@villains.com", kABHomeLabel, NULL);
    ABRecordSetValue(snidely, kABPersonEmailProperty, addr, NULL);
    ABAddressBookAddRecord(adbk, snidely, NULL);
    ABAddressBookSave(adbk, NULL);
    CFRelease(addr);
    CFRelease(snidely);
    CFRelease(adbk);
    
}

// look in console to see result

- (IBAction)doButton3:(id)sender {
    ABPeoplePickerNavigationController* picker = 
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self; // note: not merely "delegate"
    picker.displayedProperties = 
    [NSArray arrayWithObject: [NSNumber numberWithInt: kABPersonEmailProperty]];
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
    CFRelease(email);
    CFRelease(emails);
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//

- (IBAction)doButton4:(id)sender {
    ABNewPersonViewController* npvc = [[ABNewPersonViewController alloc] init];
    npvc.newPersonViewDelegate = self;
    UINavigationController* nc = 
    [[UINavigationController alloc] initWithRootViewController:npvc];
    [self presentViewController:nc animated:YES completion:nil];
}

// look in console for result; new person is created but not permanently added to user's address book

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    if (NULL != person) {
        ABAddressBookRef adbk = ABAddressBookCreate();
        ABAddressBookRemoveRecord(adbk, person, NULL);
        ABAddressBookSave(adbk, NULL);
        CFStringRef name = ABRecordCopyCompositeName(person);
        NSLog(@"I have a person named %@, but I am not saving this person to the database", name); 
        // do something with new person
        CFRelease(name);
        CFRelease(adbk);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
