
#import "ViewController.h"
#import "MyMandelbrotView.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet MyMandelbrotView* mv;
@end

@implementation ViewController
@synthesize mv;

- (IBAction) doButton: (id) sender {
    [mv drawThatPuppy];
}


@end
