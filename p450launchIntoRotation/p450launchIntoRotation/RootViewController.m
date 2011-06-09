

#import "RootViewController.h"

@implementation RootViewController

#define which 1 // and "2" and "3" for the correct way

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (which) {
        case 1: // wrong result because it's too soon
        {
            UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
            square.backgroundColor = [UIColor blackColor];
            square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5); // top center?
            [self.view addSubview:square];
            [square release];
            break;
        }
        case 2: // works, but probably not the right thing to do
        {
            [self performSelector:@selector(finishViewDidLoad) 
                       withObject:nil afterDelay:0.0];
            break;
        }
        case 3: // works, probably the right way
        {
            break;
        }
    }
}

- (void) finishViewDidLoad {
    UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    square.backgroundColor = [UIColor blackColor];
    square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5);
    [self.view addSubview:square];
    [square release];
}

- (void) finishInitializingView {
    // static BOOL flag
    static BOOL done = NO;
    if (done)
        return;
    done = YES;
    // the static BOOL flag makes sure the following is performed exactly once
    UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    square.backgroundColor = [UIColor blackColor];
    square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5);
    [self.view addSubview:square];
    [square release];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    switch (which) {
        case 3:
            [self finishInitializingView];
            break;
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    return (io == UIInterfaceOrientationLandscapeRight);
}

@end
