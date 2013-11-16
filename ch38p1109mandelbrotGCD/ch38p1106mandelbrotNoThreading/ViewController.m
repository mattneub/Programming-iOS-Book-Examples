

#import "ViewController.h"
#import "MyMandelbrotView.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet MyMandelbrotView* mv;
@end

@implementation ViewController

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction) doButton: (id) sender {
    [self.mv drawThatPuppy];
}

@end
