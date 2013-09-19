

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // direct action connection
    [self.button1 addTarget:self action:@selector(buttonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    
    // nil-targeted action
    [self.button2 addTarget:nil action:@selector(buttonPressed:)
          forControlEvents:UIControlEventTouchUpInside];

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
