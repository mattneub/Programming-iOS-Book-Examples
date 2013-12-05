

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) BOOL viewInitializationDone;
@end

@implementation ViewController

#define which 3
#if which == 1

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    square.backgroundColor = [UIColor blackColor];
    square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5); // top center?
    [self.view addSubview:square];
}

#elif which == 2

- (void) viewWillLayoutSubviews {
    if (!self->_viewInitializationDone) {
        self->_viewInitializationDone = YES;
        UIView* square = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        square.backgroundColor = [UIColor blackColor];
        square.center = CGPointMake(CGRectGetMidX(self.view.bounds),5);
        [self.view addSubview:square];
    }
}

#elif which == 3

- (void) viewDidLoad {
    [super viewDidLoad];
    UIView* square = [UIView new];
    square.backgroundColor = [UIColor blackColor];
    [self.view addSubview:square];
    square.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat side = 10;
    [square addConstraint:
     [NSLayoutConstraint
      constraintWithItem:square attribute:NSLayoutAttributeWidth
      relatedBy:0
      toItem:nil attribute:0
      multiplier:1 constant:side]];
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[square(side)]"
      options:0 metrics:@{@"side":@(side)}
      views:@{@"square":square}]];
    [self.view addConstraint:
     [NSLayoutConstraint
      constraintWithItem:square attribute:NSLayoutAttributeCenterX
      relatedBy:0
      toItem:self.view attribute:NSLayoutAttributeCenterX
      multiplier:1 constant:0]];
}


#endif

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"%@", @"did rotate");
}

@end
