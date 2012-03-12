

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, copy) NSString* alertString;
@end

@implementation RootViewController 
@synthesize alertString;

- (IBAction)doAlertView:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Not So Fast!" 
                                                    message:@"Do you really want to do this tremendously destructive thing?" 
                                                   delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", @"Maybe", nil];
    [alert show];
}

- (IBAction)doAlertView2:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enter a number:" 
                                                    message:nil 
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [tf addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.alertString = @"";
    [alert show];
}

- (void) textChanged: (UITextField*) tf {
    self.alertString = tf.text;
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        UITextField* tf = [alertView textFieldAtIndex:0];
        return [tf.text length] > 0;
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"clicked button %i", buttonIndex);
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
        NSLog(@"user entered: %@", self.alertString);
}

- (IBAction)doActionSheet:(id)sender {
    UIActionSheet* sheet = 
    [[UIActionSheet alloc] initWithTitle:@"Choose New Layout" delegate:self 
                       cancelButtonTitle:(NSString *)@"Cancel" destructiveButtonTitle:nil 
                       otherButtonTitles:@"3 by 3", @"4 by 3", @"4 by 4", @"5 by 4", @"5 by 5",
     nil];
    [sheet showInView: self.view.window.rootViewController.view];
    // try "self.view" to get a nice error message at runtime
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)ix {
    if (ix == as.cancelButtonIndex) {
        NSLog(@"Cancelled");
        return;
    }
    NSString* s = [as buttonTitleAtIndex:ix];
    NSLog(@"%@", s);
}



@end
