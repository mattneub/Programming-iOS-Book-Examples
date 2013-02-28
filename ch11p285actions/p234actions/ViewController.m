

#import "ViewController.h"

@implementation ViewController {
    IBOutlet UIButton* b1;
    IBOutlet UIButton* b2;
}

- (void) viewDidLoad {
    [b1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [b2 addTarget:nil action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonPressed: (id) sender {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Howdy!"
                                                 message:@"You tapped me." 
                                                delegate:nil 
                                       cancelButtonTitle:@"Cool"
                                       otherButtonTitles:nil];
    [av show];
}



@end
