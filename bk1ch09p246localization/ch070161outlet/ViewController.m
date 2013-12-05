

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) buttonPressed: (id) sender {
    UIAlertView* av = [[UIAlertView alloc]
                       initWithTitle:NSLocalizedString(@"AlertGreeting", nil)
                       message:NSLocalizedString(@"YouTappedMe", nil)
                       delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"Cool", nil)
                       otherButtonTitles:nil];
    [av show];
}


@end
