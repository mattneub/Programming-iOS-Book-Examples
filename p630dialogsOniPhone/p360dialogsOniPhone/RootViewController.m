

#import "RootViewController.h"

@implementation RootViewController

- (IBAction)doAlertView:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Not So Fast!" 
                                                    message:@"Do you really want to do this tremendously destructive thing?" 
                                                   delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", @"Maybe", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"clicked button %i", buttonIndex);
}

- (IBAction)doActionSheet:(id)sender {
    UIActionSheet* sheet = 
    [[UIActionSheet alloc] initWithTitle:@"Choose New Layout" delegate:self 
                       cancelButtonTitle:(NSString *)@"Cancel" destructiveButtonTitle:nil 
                       otherButtonTitles:@"3 by 3", @"4 by 3", @"4 by 4", @"5 by 4", @"5 by 5",
     nil];
    [sheet showInView: self.view];
    [sheet release];
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
