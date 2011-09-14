

#import "RootViewController.h"
#import "MyMandelbrotView.h"

@implementation RootViewController

@synthesize mv;

- (void)dealloc
{
    [mv release];
    [super dealloc];
}

- (IBAction) doButton: (id) sender {
    [mv drawThatPuppy];
}

@end
