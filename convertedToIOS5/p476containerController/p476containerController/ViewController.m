

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation ViewController {
    int cur;
    NSMutableArray* swappers;
}
@synthesize panel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self -> swappers = [NSMutableArray array];
        [self->swappers addObject: [[FirstViewController alloc] init]];
        [self->swappers addObject: [[SecondViewController alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIViewController* vc = [self->swappers objectAtIndex: cur];
    [self addChildViewController:vc]; // "will" called for us
    vc.view.frame = self.panel.bounds;
    [self.panel addSubview: vc.view];
    // note: when we call add, we must call "did" afterwards
    [vc didMoveToParentViewController:self];
        
}

- (IBAction)doFlip:(id)sender {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIViewController* fromvc = [self->swappers objectAtIndex:cur];
    cur = (cur == 0) ? 1 : 0;
    UIViewController* tovc = [self->swappers objectAtIndex:cur];
    tovc.view.frame = self.panel.bounds;
    
    // must have both as children before we can transition between them
    [self addChildViewController:tovc]; // "will" called for us
    // note: when we call remove, we must call "will" (with nil) beforehand
    [fromvc willMoveToParentViewController:nil];
    
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL done){
                                // note: when we call add, we must call "did" afterwards
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController]; // "did" called for us
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
